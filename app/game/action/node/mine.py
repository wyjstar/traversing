# -*- coding:utf-8 -*-
"""
Created on 2014-11-24

@author: hack
"""
from app.proto_file import mine_pb2
from app.proto_file import common_pb2
from app.game.core import item_group_helper
from app.game.core.drop_bag import BigBag
from app.game.redis_mode import tb_character_info

from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle

from shared.utils.const import const
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonGroupItem

from app.game.action.node._fight_start_logic import pve_process_check
from app.game.action.node._fight_start_logic import pve_process
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.battle.server_process import get_seeds
from app.game.core.mail_helper import send_mail
from app.game.core.task import hook_task, CONDITIONId
from shared.utils import xtime
from app.game.component.character_mine import MineType
from shared.tlog import tlog_action
from app.game.action.node.line_up import line_up_info
from app.game.action.node.pvp_rank import get_pvp_data
import time
from shared.common_logic.feature_open import is_not_open, FO_MINE
from app.game.core.activity import target_update

remote_gate = GlobalObject().remote.get('gate')


def get_blue_units(uid):
    record = get_pvp_data(uid)
    if not record:
        logger.error('player id is not found:%s', uid)
        return None

    return record


def mine_status(player, response):
    """
    所有矿点状态
    """
    reset_today, reset_free, reset_count = player.mine.reset_times
    response.reset_today = reset_today
    response.reset_free = reset_free
    response.reset_count = reset_count
    mine_status = player.mine.mine_status()
    player.mine.save_data()
    for mstatus in mine_status:
        print mstatus
        one_mine = response.mine.add()
        position = mstatus.get('position', None)
        if position is not None:
            one_mine.position = position
        mtype = mstatus.get('type', None)
        if mtype is not None:
            one_mine.type = mtype
        status = mstatus.get('status', None)
        if status is not None:
            one_mine.status = status
        nickname = mstatus.get('nickname', None)
        if nickname is not None:
            one_mine.nickname = nickname
        last_time = mstatus.get('last_time', None)
        if last_time is not None:
            one_mine.last_time = int(last_time)
        gen_time = mstatus.get('gen_time', None)
        if gen_time is not None:
            one_mine.gen_time = int(gen_time)
        mine_id = mstatus.get('mine_id', None)
        if mine_id is not None:
            one_mine.mine_id = int(mine_id)

        if one_mine.type == MineType.PLAYER_FIELD:
            uid = mstatus.get('uid')
            if uid == player.base_info.id:
                one_mine.fight_power =\
                    int(player.line_up_component.combat_power)
                one_mine.is_guild = player.guild.g_id
            else:
                one_mine.is_friend = player.friends.is_friend(uid)
                data_obj = tb_character_info.getObj(uid)
                if data_obj.exists():
                    data = data_obj.hmget(['guild_id', 'attackPoint'])
                    one_mine.is_guild = data['guild_id'] != player.guild.g_id
                    one_mine.fight_power = int(data['attackPoint'])
                else:
                    logger.errr('mine info cant find uid:%s', uid)

    return response


def one_mine_info(player, mstatus, one_mine):
    position = mstatus.get('position', None)
    if position is not None:
        one_mine.position = position
    mtype = mstatus.get('type', None)
    if mtype is not None:
        one_mine.type = mtype
    status = mstatus.get('status', None)
    if status is not None:
        one_mine.status = status
    nickname = mstatus.get('nickname', None)
    if nickname is not None:
        one_mine.nickname = nickname
    last_time = mstatus.get('last_time', None)
    if last_time is not None:
        one_mine.last_time = int(last_time)
    gen_time = mstatus.get('gen_time', None)
    if gen_time is not None:
        one_mine.gen_time = int(gen_time)
    seek_help = mstatus.get('seek_help', None)
    if seek_help is not None:
        one_mine.seek_help = int(seek_help)
    mine_id = mstatus.get('mine_id', None)
    if mine_id is not None:
        one_mine.mine_id = int(mine_id)

    if one_mine.type == MineType.PLAYER_FIELD:
        uid = mstatus.get('uid')
        if uid == player.base_info.id:
            one_mine.fight_power = int(player.line_up_component.combat_power)
            one_mine.is_guild = player.guild.g_id
        else:
            one_mine.is_friend = player.friends.is_friend(uid)
            data_obj = tb_character_info.getObj(uid)
            if data_obj.exists():
                data = data_obj.hmget(['guild_id', 'attackPoint'])
                one_mine.is_guild = data['guild_id'] != 0
                one_mine.fight_power = int(data['attackPoint'])
            else:
                logger.errr('mine info cant find uid:%s', uid)


@remoteserviceHandle('gate')
def query_1240(data, player):
    """
    查询所有矿点信息
    """
    response = mine_pb2.mineUpdate()
    mine_status(player, response)
    player.mine.save_data()
    logger.debug('1240-response:%s', response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def search_1241(data, player):
    """ 搜索矿点,ok """
    # print 'search_1241'
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.searchResponse()
    response.position = request.position
    logger.debug('response.position:%s', response.position)
    if player.mine.can_search(request.position):
        player.mine.search_mine(request.position)
        player.mine.save_data()
        one_mine = player.mine.mine_info(request.position)
        one_mine_info(player, one_mine, response.mine)
        response.res.result = True
        hook_task(player, CONDITIONId.MINE_EXPLORE, 1)
    else:
        response.res.result = False
        response.res.result_no = 12410
        response.res.message = u"超出探索范围"
    # print '1241-response', response

    player.mine.save_data()
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def reset_1242(data, player):
    """
    重置地图,ok
    """
    request = mine_pb2.resetMap()
    request.ParseFromString(data)
    response = mine_pb2.resetResponse()
    response.free = request.free
    # print '1242-request', request
    reset_pos = []
    if request.free == 1:
        if player.mine.can_reset_free():
            reset_pos = player.mine.reset_map()
            mine_status(player, response.mine)
            response.res.result = True
        else:
            response.res.result = False
            response.res.result_no = 12420
            response.res.message = u"免费次数已用完"
    else:
        if not player.mine.can_reset():
            response.res.result = False
            response.res.result_no = 12421
            response.res.message = u"重置次数已用完"
        else:
            reset_price = player.mine.reset_price()
            price = CommonGroupItem(0, reset_price, reset_price, const.GOLD)
            result = item_group_helper.is_afford(player, [price])  # 校验
            if not result.get('result'):
                response.res.result = False
                response.res.result_no = result.get('result_no')
                response.res.message = u'消费不足！'
            else:
                need_gold = item_group_helper.get_consume_gold_num([price])

                def func():
                    consume_data = item_group_helper.consume(player,
                                                             [price],
                                                             const.MINE_RESET)
                    item_group_helper.get_return(player,
                                                 consume_data,
                                                 response.consume)
                    reset_pos = player.mine.reset_map()
                    mine_status(player, response.mine)
                    response.res.result = True
                player.pay.pay(need_gold, const.MINE_RESET, func)
    player.mine.save_data()
    player.act.mine_refresh()
    target_update(player, [56])

    reset_times, _, _ = player.mine.reset_times
    tlog_action.log('MineReset', player, reset_times,
                    str(reset_pos))
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def query_1243(data, player):
    """ 查看矿点详细信息 """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.mineDetail()
    response.position = request.position
    detail_info = player.mine.detail_info(request.position)

    # print detail_info
    last_increase = detail_info.get('increase', 0)
    stype = detail_info['type']
    mine_item = game_configs.mine_config[detail_info['mine_id']]
    limit = mine_item.outputLimited
    normal = detail_info['normal']
    lucky = detail_info['lucky']
    guard_time = detail_info.get('guard_time', 0)
    stage_id = detail_info.get('stage_id', 0)
    seek_help = detail_info.get('seek_help', 0)

    response.res.result = True
    mstatus = player.mine.mine_info(request.position)
    one_mine_info(player, mstatus, response.mine)
    response.limit = limit
    for sid, num in normal.items():
        one_type = response.normal.add()
        one_type.stone_id = int(sid)
        one_type.stone_num = num

    for sid, num in lucky.items():
        one_type = response.lucky.add()
        one_type.stone_id = int(sid)
        one_type.stone_num = num

    response.increase = int(last_increase)
    if stype == 2:
        response.stage_id = int(stage_id)
        response.seek_help = seek_help
        line_up_info(player, response.lineup)
    if stype == 1:
        response.accelerate_times = detail_info.get('accelerate_times', 0)
        _uid = detail_info['uid']
        char_obj = tb_character_info.getObj(_uid)
        if char_obj.exists():
            lineup = char_obj.hget('copy_slots')
            response.lineup.ParseFromString(lineup)

    mid = player.mine.mid(request.position)
    mine_item = game_configs.mine_config.get(mid)

    response.genUnit = mine_item.timeGroup1 / mine_item.outputGroup1
    response.rate = mine_item.increase
    response.incrcost = mine_item.increasePrice
    response.guard_time = int(guard_time)

    player.mine.save_data()
    print response, '=========================aaa'
    return response.SerializePartialToString()


def add_stones(player, stones, response):
    for stone_id, num in stones.items():
        add_items(player, response, [stone_id], num=num)
        # for _ in range(num):
        #     runt_no = player.runt.add_runt(stone_id)
        #     if not runt_no:
        #         return 0
        #     else:
        #         runt_info = player.runt.m_runt.get(runt_no)
        #         runt_pb = response.runt.add()
        #         [runt_id, main_attr, minor_attr] = runt_info
        #         # print runt_no
        #         player.runt.deal_runt_pb(runt_no,
        #                                  runt_id,
        #                                  main_attr,
        #                                  minor_attr,
        #                                  runt_pb)
    return 1


@remoteserviceHandle('gate')
def harvest_1245(data, player):
    """
    收获符文石,待测试
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.drawStones()
    response.position = request.position
    detail_info = player.mine.detail_info(request.position)
    normal = detail_info['normal']
    lucky = detail_info['lucky']

    num = sum(normal.values()) + sum(lucky.values())
    if player.runt.bag_is_full(num):
        response.res.result = False
        response.res.result_no = 124501
        logger.error('mine harvest bag is full!')
        return response.SerializePartialToString()

    normal, lucky = player.mine.harvest(request.position)
    if normal:
        if not add_stones(player, normal, response.normal):
            response.res.result = False
            response.res.result_no = 124502
            logger.error('mine harvest add stones fail!')
            return response.SerializePartialToString()
        if not add_stones(player, lucky, response.lucky):
            response.res.result = False
            response.res.result_no = 124503
            logger.error('mine harvest add stones fail!')
            return response.SerializePartialToString()
    else:
        response.res.result = False
        response.res.result_no = 124504
        response.res.message = u"没有可以领取的符文石"
        logger.error('mine harvest no stones to harvest!')
        return response.SerializePartialToString()

    player.mine.save_data()
    player.runt.save()
    player.act.mine_get_runt()
    target_update(player, [58])
    hook_task(player, CONDITIONId.GAIN_RUNT, 1)
    tlog_action.log('MineHarvest',
                    player,
                    request.position,
                    str(normal),
                    str(lucky))
    response.res.result = True
    logger.debug('mine harvest:%s', response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def query_shop_1247(data, player):
    """
    查看神秘商人信息,ok
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    shop_ids = player.mine.shop_info(request.position)
    response = mine_pb2.shopStatus()
    if shop_ids:
        response.res.result = True
        for shop_id, status in shop_ids.items():
            one_shop = response.shop.add()
            one_shop.shop_id = shop_id
            one_shop.status = status
    else:
        response.res.result = False
        response.res.message = u"商人不存在"
    player.mine.save_data()
    # print 'query_shop_1247-response', response
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def exchange_1248(data, player):
    """
    神秘商人兑换,ok
    """
    request = mine_pb2.exchangeRequest()
    request.ParseFromString(data)
    response = mine_pb2.exchangeResponse()
    response.position = request.position
    response.shop_id = request.shop_id
    common_response = response.res

    # print "mijing shop id:", request.shop_id
    shop_item = game_configs.shop_config.get(request.shop_id)
    result = item_group_helper.is_afford(player, shop_item.discountPrice)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.result_no = result.get('result_no')
        common_response.message = u'消费不足！'
        return response.SerializePartialToString()
    if shop_item.type != 7:
        common_response.result = False
        common_response.result_no = 12480
        common_response.message = u'非密境商店商品！'
        return response.SerializePartialToString()
    ret, message = player.mine.can_buy(request.position, request.shop_id)
    if ret != 0:
        common_response.result = False
        common_response.result_no = ret
        common_response.message = message
        return response.SerializePartialToString()

    need_gold = item_group_helper.get_consume_gold_num(shop_item.discountPrice)

    def func():
        consume_data = item_group_helper.consume(player,
                                                 shop_item.discountPrice,
                                                 const.MINE_EXCHANGE)  # 消耗
        return_data = item_group_helper.gain(player,
                                             shop_item.gain,
                                             const.MINE_EXCHANGE)  # 获取
        # extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
        item_group_helper.get_return(player, consume_data, response.consume)
        item_group_helper.get_return(player, return_data, response.gain)
        # get_return(player, extra_return_data, response)
        player.mine.buy_shop(request.position, request.shop_id)
        player.mine.save_data()

    player.pay.pay(need_gold, const.MINE_EXCHANGE, func)

    return response.SerializePartialToString()


def add_items(player, response, drop_ids, num=1):
    """ 添加道具给玩家 """
    for drop_id in drop_ids:
        big_bag = BigBag(drop_id)
        drop_item_group = big_bag.get_drop_items()
        return_data = item_group_helper.gain(player,
                                             drop_item_group,
                                             const.MINE_REWARD,
                                             multiple=num
                                             )
        item_group_helper.get_return(player, return_data, response)
    return response


@remoteserviceHandle('gate')
def reward_1249(data, player):
    """
    宝箱领奖,ok
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.boxReward()
    response.position = request.position
    items = response.data
    if not player.mine.reward(request.position):
        items.res.result = False
        items.res.result_no = 12490
        items.res.message = u"已领取"
        return items.SerializePartialToString()
    player.mine.save_data()
    drop_id = game_configs.base_config['warFogChest']
    add_items(player, items.gain, [drop_id])
    # print 'reward_1249-response', response
    tlog_action.log('MineBox', player)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def acc_mine_1250(data, player):
    """
    增产, 只有主矿能增产, 增产累计时长,ok
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.IncreaseResponse()

    detail_info = player.mine.detail_info(request.position)
    last_increase = detail_info['increase']

    now = xtime.timestamp()
    main_mine = game_configs.mine_config.get(10001)
    if last_increase + main_mine.increasTime * 60 - now > main_mine.increasMaxTime * 60:
        response.res.result = True
        response.result_no = 12501
        return response.SerializePartialToString()

    mine_item = game_configs.mine_config[detail_info['mine_id']]
    increasePrice = mine_item.increasePrice

    price = CommonGroupItem(0, increasePrice, increasePrice, const.GOLD)
    result = item_group_helper.is_afford(player, [price])  # 校验
    if not result.get('result'):
        response.res.result = False
        response.res.result_no = result.get('result_no')
        response.res.message = u'消费不足！'
        return response.SerializePartialToString()
    else:
        response.res.result = True
    # print 'price', price
    need_gold = item_group_helper.get_consume_gold_num([price])

    def func():
        consume_return_data = item_group_helper.consume(player,
                                                        [price],
                                                        const.MINE_ACC)
        item_group_helper.get_return(player,
                                     consume_return_data,
                                     response.consume)

    player.pay.pay(need_gold, const.MINE_ACC, func)
    last_time = player.mine.increase_mine()
    player.mine.save_data()
    tlog_action.log('MineAcc', player, time.strftime("%Y-%m-%d %X",
                    time.localtime(int(last_time))))

    response.position = 0
    response.last_time = int(last_time)
    return response.SerializePartialToString()


def process_mine_result(player, position, fight_result,
                        response, stype, hold=1):
    """
    玩家占领其他人的野怪矿，更新矿点数据，给玩家发送奖励，给被占领玩家发送奖励
    @param gain: true or false
    """
    result = player.mine.settle(position, fight_result, hold)
    normal = result['normal']
    lucky = result['lucky']

    if stype != 1:
        return
    # print 'process mine result:', normal, lucky

    target = result['old_uid']
    nickname = result['old_nickname']

    if fight_result is not True:
        send_mail(conf_id=122, receive_id=target, nickname=player.base_info.base_name)
        return

    warFogLootRatio = game_configs.base_config['warFogLootRatio']
    normal_a = {}
    normal_b = {}
    lucky_a = {}
    lucky_b = {}

    for k, v in normal.items():
        if v > 0:
            normal_a[k] = int(v*warFogLootRatio)
            normal_b[k] = v - int(v*warFogLootRatio)

    for k, v in lucky.items():
        if v > 0:
            lucky_a[k] = int(v*warFogLootRatio)
            lucky_b[k] = v - int(v*warFogLootRatio)

    prize = []
    prize_num = 0
    for k, v in normal_b.items():
        prize.append({106: [v, v, k]})
        prize_num += v
    for k, v in lucky_b.items():
        prize.append({106: [v, v, k]})
        prize_num += v

    logger.debug('pvp mine total:normal %s-%s lucky %s-%s prize:%s',
                 normal_a, normal_b, lucky_a, lucky_b, prize)

    if not add_stones(player, normal_a, response.gain):
        response.res.result = False
        response.res.result_no = 824
        logger.error('add_stones fail!!!!!!')
    if not add_stones(player, lucky_a, response.gain):
        response.res.result = False
        response.res.result_no = 824
        logger.error('add_stones fail!!!!!!')

    mail_id = game_configs.base_config.get('warFogRobbedMail')
    send_mail(conf_id=mail_id, receive_id=target, rune_num=prize_num,
              prize=str(prize), nickname=player.base_info.base_name)


@remoteserviceHandle('gate')
def settle_1252(data, player):
    request = mine_pb2.MineSettleRequest()
    response = common_pb2.CommonResponse()
    request.ParseFromString(data)
    pos = request.pos
    result = request.result
    is_pvp = player.mine.is_pvp(pos)  # 根据矿所在位置判断pve or pvp
    logger.debug("pos %s, mine_info %s" % (pos, is_pvp))
    pve_check_result = pve_process_check(player,
                                         result,
                                         request.steps,
                                         const.BATTLE_MINE_PVE)
    if is_pvp is False and not pve_check_result:
        logger.error("mine pve_process_check error!!!!!")
        res = response.res
        res.result = False
        res.result_no = 9041
        return response.SerializePartialToString()
    # todo: set settle time to calculate acc_mine
    process_mine_result(player, pos, result, None, 0, 1)
    # 7日奖励 占领矿点
    mine_id = player.mine._mine[pos].get("mine_id")
    mine_item = game_configs.mine_config.get(mine_id)
    logger.debug("mine_id %s mine_item %s" % (mine_id, mine_item))
    if mine_item:
        player.act.mine_win(mine_item.quality)
        target_update(player, [57])

    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def battle_1253(data, player):
    """docstring for battle"""
    request = mine_pb2.MineBattleRequest()
    request.ParseFromString(data)
    pos = request.pos                    # 矿所在位置
    line_up = request.lineup            # 阵容顺序
    red_best_skill_id = request.unparalleled  # 无双编号
    red_units = {}
    blue_units = {}
    response = mine_pb2.MineBattleResponse()

    logger.debug("%s pos" % pos)
    if is_not_open(player, FO_MINE):
        response.res.result = True
        response.res.result_no = 837
        return response.SerializePartialToString()

    mine_info = player.mine.get_info(pos)

    is_pvp = player.mine.is_pvp(pos)  # 根据矿所在位置判断pve or pvp
    # print mine_info, "*"*80
    detail_info = player.mine.detail_info(request.pos)
    if not is_pvp:
        # pve
        stage_id = mine_info.get("stage_id")        # todo: 根据pos获取关卡id
        stage_type = 8                              # 关卡类型
        stage_info = pve_process(stage_id,
                                 stage_type,
                                 line_up,
                                 0,
                                 player
                                 )
        result = stage_info.get('result')
        response.res.result = result
        if not result:
            logger.info('进入关卡返回数据:%s', response)
            response.res.result_no = stage_info.get('result_no')
            return response.SerializePartialToString()
        red_units = stage_info.get('red_units')
        blue_units = stage_info.get('blue_units')
        blue_units = blue_units[0]

        seed1, seed2 = get_seeds()
        player.fight_cache_component.seed1 = seed1
        player.fight_cache_component.seed2 = seed2
        player.fight_cache_component.red_best_skill_id = red_best_skill_id
        player.fight_cache_component.stage_info = stage_info
        response.seed1 = seed1
        response.seed2 = seed2
        # print red_units, blue_units

    else:
        # pvp
        normal = detail_info['normal']
        lucky = detail_info['lucky']
        num = sum(normal.values()) + sum(lucky.values())
        if player.runt.bag_is_full(num):
            response.res.result = False
            response.res.result_no = 125308
            logger.error('mine harvest bag is full!')
            return response.SerializePartialToString()

        player.fight_cache_component.stage_id = 0
        red_units = player.fight_cache_component.get_red_units()
        blue_data = get_blue_units(detail_info['uid'])
        blue_units = blue_data.get('copy_units')
        seed1, seed2 = get_seeds()
        if not blue_units:
            fight_result = True
        else:
            fight_result = pvp_process(player,
                                       line_up,
                                       red_units,
                                       blue_units,
                                       seed1, seed2,
                                       const.BATTLE_MINE_PVP)
        hold = request.hold
        process_mine_result(player, pos, fight_result, response, 1, hold)

        response.fight_result = fight_result
        response.seed1 = seed1
        response.seed2 = seed2

        # print red_units, blue_units

    pvp_assemble_units(red_units, blue_units, response)
    response.res.result = True
    response.hold = request.hold
    logger.debug('battle_1253:%s', response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def mine_accelerate_1254(data, player):
    """docstring for battle"""
    request = mine_pb2.MineAccelerateRequest()
    request.ParseFromString(data)
    pos = request.pos                    # 矿所在位置
    response = mine_pb2.MineAccelerateResponse()

    need_gold = player.mine.get_acc_time_gold(pos)
    if need_gold <= 0:
        logger.error('gold num error:%s', need_gold)
        response.res.result = False
        response.res.result_no = 125401
        return response.SerializePartialToString()

    price = []
    price.append(CommonGroupItem(const.COIN, need_gold, need_gold, const.GOLD))

    def func():
        consume_return_data = item_group_helper.consume(player,
                                                        price,
                                                        const.MINE_ACC)
        item_group_helper.get_return(player,
                                     consume_return_data,
                                     response.consume)
        response.res.result = player.mine.acc_mine_time(pos)

    player.pay.pay(need_gold, const.MINE_ACC, func)
    tlog_action.log('MineAccelerate', player, need_gold)
    response.res.result = True
    logger.debug('mine accelerate:%s', response)
    return response.SerializePartialToString()
