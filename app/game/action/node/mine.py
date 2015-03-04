# -*- coding:utf-8 -*-
"""
Created on 2014-11-24

@author: hack
"""
import time
from app.proto_file import mine_pb2
from app.proto_file import common_pb2
from app.proto_file import line_up_pb2
from app.proto_file import db_pb2
from app.game.core import item_group_helper
from app.game.core.drop_bag import BigBag
from app.game.core.lively import task_status

from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle

from shared.utils.const import const
from shared.db_opear.configs_data import game_configs
from shared.db_opear.configs_data.common_item import CommonGroupItem

from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
from app.game.component.achievement.user_achievement import CountEvent
from app.game.component.achievement.user_achievement import EventType
from app.game.action.node.line_up import line_up_info_detail
from app.game.action.node._fight_start_logic import pve_process
from app.game.action.node._fight_start_logic import pvp_process
from app.game.action.node._fight_start_logic import pvp_assemble_units
from app.game.action.root import netforwarding

remote_gate = GlobalObject().remote['gate']


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
    return response


def one_mine_info(mstatus, one_mine):
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


@remoteserviceHandle('gate')
def query_1240(data, player):
    """
    查询所有矿点信息
    """
    response = mine_pb2.mineUpdate()
    mine_status(player, response)
    player.mine.save_data()
    # print '1240-response', response
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def search_1241(data, player):
    """ 搜索矿点,ok """
    # print 'search_1241'
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.searchResponse()
    response.position = request.position
    # print 'response.position', response.position
    if player.mine.can_search(request.position):
        player.mine.search_mine(request.position, mine_boss)
        player.mine.save_data()
        one_mine = player.mine.mine_info(request.position)
        one_mine_info(one_mine, response.mine)
        response.res.result = True
        lively_event = CountEvent.create_event(EventType.MAGIC, 1, ifadd=True)
        tstatus = player.tasks.check_inter(lively_event)
        if tstatus:
            task_data = task_status(player)
            remote_gate.push_object_remote(1234,
                                           task_data,
                                           [player.dynamic_id])
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
    if request.free == 1:
        if player.mine.can_reset_free():
            player.mine.reset_map()
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
                consume_return_data = item_group_helper.consume(player,
                                                                [price])  # 消耗
                item_group_helper.get_return(player,
                                             consume_return_data,
                                             response.consume)
                player.mine.reset_map()
                mine_status(player, response.mine)
                response.res.result = True
    player.mine.save_data()
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def query_1243(data, player):
    """ 查看矿点详细信息 """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.mineDetail()
    response.position = request.position
    detail_info = player.mine.detail_info(request.position)
    ret, stype, last_increase, limit, normal, lucky, lineup, guard_time = detail_info
    if ret == 0:
        response.res.result = True
        mstatus = player.mine.mine_info(request.position)
        one_mine_info(mstatus, response.mine)
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
            response.stage_id = int(lineup)
        if stype == 1:
            if lineup is not None:
                response.lineup.ParseFromString(lineup.get('line_up'))

        mid = player.mine.mid(request.position)
        main_mine = game_configs.mine_config.get(mid)

        response.genUnit = int((60 / main_mine.timeGroup1) * main_mine.outputGroup1)
        response.rate = main_mine.increase
        response.incrcost = main_mine.increasePrice
        response.guard_time = int(guard_time)
    else:
        response.res.result = False
        response.res.result_no = ret

    player.mine.save_data()
    # print '1243-response', response.lineup
    return response.SerializePartialToString()


def save_guard(player, position, info):
    """ 驻守矿点 """
    result_code = player.mine.save_guard(position, info)
    return result_code


@remoteserviceHandle('gate')
def guard_1244(data, player):
    """ 驻守矿点 """
    request = mine_pb2.MineGuardRequest()
    request.ParseFromString(data)
    # print request
    response = common_pb2.CommonResponse()
    __skill = request.best_skill_id
    __best_skill_no, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)

    # 构造阵容组件
    character_line_up = CharacterLineUpComponent(player)
    save_slot = {}
    for slot in request.line_up_slots:
        line_up_slot = LineUpSlotComponent(character_line_up,
                                           slot.slot_no,
                                           activation=True,
                                           hero_no=slot.hero_no)
        save_slot[slot.hero_no] = []
        for equipment_slot in slot.equipment_slots:
            temp_slot = EquipmentSlotComponent(line_up_slot,
                                               equipment_slot.slot_no,
                                               activation=True,
                                               equipment_id=equipment_slot.equipment_id)

            line_up_slot.equipment_slots[equipment_slot.slot_no] = temp_slot
            # 标记装备已驻守
            logger.debug(equipment_slot.equipment_id)
            equip = player.equipment_component.get_equipment(equipment_slot.equipment_id)
            if not equip:
                continue
            equip.attribute.is_guard = True
            equip.save_data()
            save_slot[slot.hero_no].append(equipment_slot.equipment_id)

        character_line_up.line_up_slots[slot.slot_no] = line_up_slot
        logger.debug(line_up_slot.hero_slot.hero_no)
        logger.debug("hero_no")

        # 标记武将已驻守
        hero = player.hero_component.get_hero(slot.hero_no)
        hero.is_guard = True
        hero.save_data()
    battle_units = {}  # 需要保存的阵容信息
    for no, slot in character_line_up.line_up_slots.items():
        unit = slot.slot_attr

        if unit:
            logger.debug("unit:"+str(unit.unit_no))
            battle_units[no] = unit

    line_up_response = line_up_pb2.LineUpResponse()
    line_up_info_detail(character_line_up.line_up_slots, {}, line_up_response)
    add_unpar = line_up_response.unpars.add()
    add_unpar.unpar_id = __skill
    add_unpar.unpar_level = __skill_level

    # 风物志
    player.travel_component.update_travel_item(line_up_response)

    # 公会等级
    line_up_response.guild_level = player.guild.get_guild_level()

    info = {}
    info["battle_units"] = battle_units
    info["best_skill_id"] = __skill
    info["best_skill_no"] = __best_skill_no
    info["best_skill_level"] = __skill_level
    info["level"] = player.base_info.level
    info["nickname"] = player.base_info.base_name
    info["character_id"] = player.base_info.id
    info["line_up"] = line_up_response.SerializePartialToString()

    logger.debug(request)
    logger.debug("guard-----------------")
    result_code = save_guard(player, request.pos, info)
    if result_code:
        response.result = False
        response.result_no = result_code
        return response.SerializePartialToString()

    player.mine.save_slot(request.pos, save_slot)

    response.result = True
    player.mine.save_data()
    return response.SerializePartialToString()


def add_stones(player, stones, response):
    response.res.result = True

    for stone_id, num in stones.items():
        for _ in range(num):
            runt_no = player.runt.add_runt(stone_id)
            if not runt_no:
                return 0
            else:
                runt_info = player.runt.m_runt.get(runt_no)
                runt_pb = response.runt.add()
                [runt_id, main_attr, minor_attr] = runt_info
                # print runt_no
                player.runt.deal_runt_pb(runt_no,
                                         runt_id,
                                         main_attr,
                                         minor_attr,
                                         runt_pb)
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
    stones = player.mine.harvest(request.position)
    # print 'stones', stones
    if stones:
        if not add_stones(player, stones, response):
            response.res.result = False
            response.res.result_no = 824
            return response.SerializePartialToString()
        lively_event = CountEvent.create_event(EventType.WORD, 1, ifadd=True)
        tstatus = player.tasks.check_inter(lively_event)
        if tstatus:
            task_data = task_status(player)
            remote_gate.push_object_remote(1234,
                                           task_data,
                                           [player.dynamic_id])

    else:
        response.res.result = False
        response.res.result_no = 12450
        response.res.message = u"没有可以领取的符文石"

    player.mine.save_data()
    player.runt.save()
    # print '1245-response', response
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

    consume_return_data = item_group_helper.consume(player, shop_item.discountPrice)  # 消耗

    return_data = item_group_helper.gain(player, shop_item.gain, const.MINE_EXCHANGE)  # 获取
    # extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    item_group_helper.get_return(player, consume_return_data, response.consume)
    item_group_helper.get_return(player, return_data, response.gain)
    # get_return(player, extra_return_data, response)
    player.mine.buy_shop(request.position, request.shop_id)
    player.mine.save_data()

    return response.SerializePartialToString()


def add_items(player, response, drop_ids):
    """ 添加道具给玩家 """
    for drop_id in drop_ids:
        big_bag = BigBag(drop_id)
        drop_item_group = big_bag.get_drop_items()
        return_data = item_group_helper.gain(player,
                                             drop_item_group,
                                             const.MINE_REWARD)
        item_group_helper.get_return(player, return_data, response.gain)
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
    add_items(player, items, [drop_id])
    # print 'reward_1249-response', response
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def acc_mine_1250(data, player):
    """
    增产, 只有主矿能增产, 增产累计时长,ok
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.IncreaseResponse()
    increasePrice = player.mine.price(request.position)
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
    consume_return_data = item_group_helper.consume(player, [price])  # 消耗
    item_group_helper.get_return(player, consume_return_data, response.consume)
    last_time = player.mine.acc_mine()
    player.mine.save_data()

    response.position = 0
    response.last_time = int(last_time)
    return response.SerializePartialToString()


def process_mine_result(player, position, result, response, stype):
    """
    玩家占领其他人的野怪矿，更新矿点数据，给玩家发送奖励，给被占领玩家发送奖励
    @param gain: true or false
    """
    # print 'process_mine_result', position, response, result, stype
    if result is True:
        target = player.mine.settle(position)
        if stype == 1:
            detail_info = player.mine.detail_info(position)
            _, _, _, _, normal, lucky, _, _ = detail_info
            warFogLootRatio = game_configs.base_config['warFogLootRatio']
            count = {}
            for k, v in normal.items():
                if v > 0:
                    normal = response.normal.add()
                    normal.stone_id = k
                    normal.stone_num = int(v * warFogLootRatio)
                    count[k] = v
            for k, v in lucky.items():
                if v > 0:
                    luck = response.lucky.add()
                    luck.stone_id = k
                    luck.stone_num = int(v*warFogLootRatio)
                    count[k] = v

            mail = {}
            prize = {}
            prize[108] = []

            for k, v in count.items():
                prize[108].append([v, v, k])

            mail = db_pb2.Mail_PB()
            mail.sender_id = -1
            mail.sender_name = ''
            mail.receive_id = target
            mail.receive_name = ''
            mail.title = ''
            mail.content = ''
            mail.mail_type = 2
            mail.prize = prize
            mail.send_time = int(time.time())

            battle_process = db_pb2.Mail_PB()
            battle_process.sender_id = -1
            battle_process.sender_name = player.base_info.base_name
            battle_process.receive_id = target
            battle_process.receive_name = ''
            battle_process.title = ''
            battle_process.content = ''
            battle_process.mail_type = 2
            battle_process.prize = prize

            # command:id 为收邮件的命令ID
            if sum(count.values()) > 0:
                # response.result = netforwarding.push_message('receive_mail_remote', target, mail)
                netforwarding.push_message('receive_mail_remote',
                                           target,
                                           mail.SerializePartialToString())
                netforwarding.push_message('receive_mail_remote',
                                           target,
                                           battle_process.SerializePartialToString())


@remoteserviceHandle('gate')
def settle_1252(data, player):
    request = mine_pb2.MineSettleRequest()
    request.ParseFromString(data)
    pos = request.pos
    result = request.result
    # todo: check result
    # todo: set settle time to calculate acc_mine
    process_mine_result(player, pos, result, None, 0)
    response = common_pb2.CommonResponse()
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
    blue_best_skill_id = 0
    blue_best_skill_level = 0
    red_units = {}
    blue_units = {}

    logger.debug("%s pos" % pos)

    mine_info = get_mine_info(player, pos)
    response = mine_pb2.MineBattleResponse()

    mine_type = mine_info.get("mine_type")  # 根据矿所在位置判断pve or pvp
    # print mine_type, "*"*80
    # print request
    if mine_type == 0:
        # pve
        stage_id = mine_info.get("stage_id")        # todo: 根据pos获取关卡id
        stage_type = 5                              # 关卡类型
        stage_info = pve_process(stage_id,
                                 stage_type,
                                 line_up,
                                 0,
                                 player,
                                 red_best_skill_id)
        result = stage_info.get('result')
        response.res.result = result
        if not result:
            logger.info('进入关卡返回数据:%s', response)
            response.res.result_no = stage_info.get('result_no')
            return response.SerializePartialToString()
        red_units = stage_info.get('red_units')
        blue_units = stage_info.get('blue_units')
        blue_units = blue_units[0]

        # # print red_units, blue_units

    elif mine_type == 1:
        # pvp
        red_units = player.fight_cache_component.red_unit
        info = get_save_guard(player, pos)
        blue_units = info.get("battle_units")

        fight_result = pvp_process(player,
                                   line_up,
                                   red_units,
                                   blue_units,
                                   red_best_skill_id,
                                   info.get("best_skill_no"),
                                   info.get("level"))
        if fight_result:
            # 返回秘境的结果
            pass
        process_mine_result(player, pos, response, fight_result, mine_type)

        blue_best_skill_id = info.get("best_skill_id", 0)
        blue_best_skill_level = info.get("best_skill_level", 0)

        # print red_units, blue_units

    red_best_skill_no, red_best_skill_level = player.line_up_component.get_skill_info_by_unpar(red_best_skill_id)
    response.red_best_skill_id = red_best_skill_id
    response.red_best_skill_level = red_best_skill_level
    response.blue_best_skill_id = blue_best_skill_id
    response.blue_best_skill_level = blue_best_skill_level
    pvp_assemble_units(red_units, blue_units, response)
    response.res.result = True
    return response.SerializePartialToString()


def get_mine_info(player, pos):
    """根据pos获取关卡info.
    矿的类型：mine type 0/1
    如果野怪驻守的矿：关卡id
    玩家驻守的矿：
    """
    mine_info = player.mine.get_info(pos)
    return mine_info


def get_save_guard(player, pos):
    """ 获取保存的驻守信息 """
    info = player.mine.get_guard_info(pos)
    if info is None:
        return {}
    return info


def mine_boss():
    result = remote_gate['world'].trigger_mine_boss_remote()
    return result

# @remoteserviceHandle('gate')
# def trigger_mine_boss_1259(data, player):
#     """
#     仅供测试，触发秘境boss
#     return {"result":True, "boss_id": boss_id}
#     """
#
#     result = remote_gate['world'].trigger_mine_boss_remote()
#     assert result, "trigger_mine_boss"
#     response = common_pb2.CommonResponse()
#     response.result = True
#     return response.SerializePartialToString()
