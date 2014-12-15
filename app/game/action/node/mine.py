# -*- coding:utf-8 -*-
'''
Created on 2014-11-24

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import mine_pb2, item_response_pb2, common_pb2
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data.game_configs import shop_config, base_config,\
    mine_config
from app.game.core import item_group_helper
from app.game.core.drop_bag import BigBag
from shared.db_opear.configs_data.common_item import CommonGroupItem
from shared.utils.const import const
from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
import cPickle
from app.proto_file import pvp_rank_pb2
from app.battle.battle_process import BattlePVPProcess
from gfirefly.server.logobj import logger
from app.game.action.node.line_up import line_up_info
from app.game.action.node._fight_start_logic import pve_process, pvp_process, pvp_assemble_units
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
        if position != None:
            one_mine.position = position
        mtype = mstatus.get('type', None)
        if mtype != None:
            one_mine.type = mtype
        status = mstatus.get('status', None)
        if status != None:
            one_mine.status = status
        nickname = mstatus.get('nickname', None)
        if nickname != None:
            one_mine.nickname = nickname
        last_time = mstatus.get('last_time', None)
        if last_time != None:
            one_mine.last_time = last_time
        gen_time = mstatus.get('gen_time', None)
        if gen_time != None:
            one_mine.gen_time = int(gen_time)
    return response

def one_mine_info(mstatus, one_mine):
        position = mstatus.get('position', None)
        if position != None:
            one_mine.position = position
        mtype = mstatus.get('type', None)
        if mtype != None:
            one_mine.type = mtype
        status = mstatus.get('status', None)
        if status != None:
            one_mine.status = status
        nickname = mstatus.get('nickname', None)
        if nickname != None:
            one_mine.nickname = nickname
        last_time = mstatus.get('last_time', None)
        if last_time != None:
            one_mine.last_time = last_time
        gen_time = mstatus.get('gen_time', None)
        if gen_time != None:
            one_mine.gen_time = int(gen_time)

@remoteserviceHandle('gate')
def query_1240(data, player):
    """
    查询所有矿点信息
    """
    response = mine_pb2.mineUpdate()
    mine_status(player, response)
    player.mine.save_data()
    print '1240-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def search_1241(data, player):
    """
    搜索矿点,ok
    """
    print 'search_1241'
#     try:
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.searchResponse()
    response.position = request.position
    print 'response.position', response.position
    if player.mine.can_search(request.position):
        player.mine.search_mine(request.position, trigger_mine_boss)
        player.mine.save_data()
        one_mine = player.mine.mine_info(request.position)
        one_mine_info(one_mine, response.mine)
        response.res.result = True
    else:
        response.res.result = False
        response.res.result_no = 12410
        response.res.message = u"超出探索范围"
    print '1241-response', response
#     except Exception, e:
#         print 'search', e

    player.mine.save_data()
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def reset_1242(data, player):
    """
    重置地图,ok
    """
    request  = mine_pb2.resetMap()
    request.ParseFromString(data)
    response  = mine_pb2.resetResponse()
    response.free = request.free
    print '1242-request', request
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
                consume_return_data = item_group_helper.consume(player, [price])  # 消耗
                item_group_helper.get_return(player, consume_return_data, response.consume)
                player.mine.reset_map()
                mine_status(player, response.mine)
                response.res.result = True
    player.mine.save_data()
    #print '1242-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def query_1243(data, player):
    """
    查看矿点详细信息
    """
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
            response.lineup.ParseFromString(lineup)

        mid = player.mine.mid(request.position)
        main_mine = mine_config.get(mid)

        response.genUnit = int( (60 / main_mine.timeGroup1) * main_mine.outputGroup1)
        response.rate = main_mine.increase
        response.incrcost = main_mine.increasePrice
        response.guard_time = guard_time
    else:
        response.res.result = False
        response.res.result_no = ret

    player.mine.save_data()
    print '1243-response', response
    return response.SerializePartialToString()

def save_guard(player, position, info):
    """
    驻守矿点
    """
    result_code = player.mine.save_guard(position, info)
    return result_code

@remoteserviceHandle('gate')
def guard_1244(data, player):
    """
    驻守矿点
    """
    request = mine_pb2.MineGuardRequest()
    request.ParseFromString(data)
    response = common_pb2.CommonResponse()
    __skill = request.best_skill_id
    __best_skill_no, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)

    #构造阵容组件
    character_line_up = CharacterLineUpComponent(player)
    for slot in request.line_up_slots:
        line_up_slot = LineUpSlotComponent(player, slot.slot_no, activation=True, hero_no=slot.hero_no)

        for equipment_slot in slot.equipment_slots:
            equipment_slot = EquipmentSlotComponent(equipment_slot.slot_no, activation=True, equipment_id=slot.equipment_id)
            line_up_slot.equipment_slots[equipment_slot.slot_no] = equipment_slot
            # 标记装备已驻守
            equip = player.equipment_component.get_equipment(slot.equipment_id)
            equip.attribute.is_guard = True

        character_line_up.line_up_slots[slot.slot_no] = line_up_slot

        # 标记武将已驻守
        hero = player.hero_component.get_hero(slot.hero_no)
        hero.is_guard = True


    battle_units = {} #需要保存的阵容信息
    for no, slot in character_line_up.line_up_slots.items():
        unit = slot.slot_attr
        if unit:
            battle_units[no] = unit

    info = {}
    info["battle_units"] = battle_units
    info["best_skill_id"] = __skill
    info["best_skill_no"] = __best_skill_no
    info["best_skill_level"] = __skill_level
    info["level"] = player.level.level
    info["nickname"] = player.base_info.nickname
    info["character_id"] = player.base_info.id
    info["line_up"] = line_up_info(player).SerializePartialToString()

    result_code = save_guard(player, request.pos, info)
    if result_code:
        response.res.result = False
        response.res.result_no = result_code
        return response.SerializePartialToString()

    response.res.result = True
    player.mine.save_data()
    return response.SerializePartialToString()


def add_stones(player, stones, response):
    response.res.result = True
    for stone_id, num in stones.items():
        #player.stone.add_stones(stone_id, num)
        one_type = response.stones.add()
        one_type.stone_id = stone_id
        one_type.stone_num = num
    #player.stone.save_data()

@remoteserviceHandle('gate')
def harvest_1245(data, player):
    """
    收获符文石,待测试
    """
    request = mine_pb2.positionRequest()
    #request.ParseFromString(data)
    request.position = 0
    response = mine_pb2.drawStones()
    response.position = request.position
    stones = player.mine.harvest(request.position)
    print 'stones', stones
    if stones:
        add_stones(player, stones, response)
    else:
        response.res.result = False
        response.res.result_no = 12450
        response.res.message = u"没有可以领取的符文石"

    player.mine.save_data()
    print '1245-response', response
    return response.SerializePartialToString()




# @remoteserviceHandle('gate')
# def battle_1246(data, player):
#     """
#     攻占怪物驻守的矿点
#     1. 如果矿点为怪物驻守 则发送903协议， 走pve逻辑
#     2. 如果矿点为玩家驻守 则发送1246协议， 走pvp逻辑
#     """
#     request = mine_pb2.battleRequest()
#     request.ParseFromString(data)
#     pvp_data = request.data
#     __skill = pvp_data.skill
#     __best_skill, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)
#     save_line_up_order(pvp_data.lineup, player)
# 
#     record = {}
#     #todo: 获取驻守数据
#     blue_units = record.get('units')
#     # print "blue_units:", blue_units
#     blue_units = cPickle.loads(blue_units)
#     # print "blue_units:", blue_units
#     red_units = player.fight_cache_component.red_unit
#     process = BattlePVPProcess(red_units, __best_skill, player.level.level, blue_units,
#                                record.get('best_skill_no', 0), record.get('level', 1))
#     fight_result = process.process()
# 
#     response = mine_pb2.battleResponse()
# 
#     process_mine_result(player, request.position, response.gain, fight_result)
# 
#     logger.debug("fight result:%s" % fight_result)
# 
# 
#     response = pvp_rank_pb2.PvpFightResponse()
#     response.res.result = True
# 
# 
#     battleresponse = response.data
#     battleresponse.res.result = True
# 
# 
#     player.mine.save_data()
# 
#     return response.SerializeToString()


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
    print 'query_shop_1247-response', response
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

    print "mijing shop id:", request.shop_id
    shop_item = shop_config.get(request.shop_id)
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

    return_data = item_group_helper.gain(player, shop_item.gain)  # 获取
    # extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    item_group_helper.get_return(player, consume_return_data, response.consume)
    item_group_helper.get_return(player, return_data, response.gain)
    # get_return(player, extra_return_data, response)
    player.mine.buy_shop(request.position, request.shop_id)
    player.mine.save_data()

    return response.SerializePartialToString()

def add_items(player, response, drop_ids):
    """
    添加道具给玩家
    """

    for drop_id in drop_ids:
        big_bag = BigBag(drop_id)
        drop_item_group = big_bag.get_drop_items()
        return_data = item_group_helper.gain(player, drop_item_group)
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
    drop_id = base_config['warFogChest']
    add_items(player, items, [drop_id])
    print 'reward_1249-response', response
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
    print 'price', price
    consume_return_data = item_group_helper.consume(player, [price])  # 消耗
    item_group_helper.get_return(player, consume_return_data, response.consume)
    last_time = player.mine.acc_mine()
    player.mine.save_data()

    response.position = 0
    response.last_time = int(last_time)
    return response.SerializePartialToString()


def process_mine_result(player, position, response, result):
    """
    玩家占领其他人的野怪矿，更新矿点数据，给玩家发送奖励，给被占领玩家发送奖励
    @param gain: true or false
    """
    if result == True:
        target = player.mine.settle(position)
        detail_info = player.mine.detail_info(position)
        _, _, _, _, normal, lucky, _, _ = detail_info
        warFogLootRatio = base_config['warFogLootRatio']
        for k, v in normal.items():
            normal = response.normal.add()
            normal[k] = int(v *warFogLootRatio)
        for k, v in lucky.items():
            luck = response.lucky.add()
            luck[k] = int(v*warFogLootRatio)
        
        """
            required string mail_id = 1; // ID
            optional int32 sender_id = 2; //发件人ID
            optional string sender_name = 3; //发件人
            optional int32 sender_icon = 4; //发件人Icon
            optional int32 receive_id = 5; //收件人ID
            optional string receive_name = 6; //收件人
            optional string title = 7; //标题
            optional string content = 8; //邮件内容
            required int32 mail_type = 9; //邮件类型
            optional int32 send_time = 10; //发件时间
            optional bool is_readed = 11; //是否已读
            optional string prize = 12; //奖品
        """
        mail = {}
        # command:id 为收邮件的命令ID
        response.result = netforwarding.push_message('receive_mail_remote', target, mail)

@remoteserviceHandle('gate')
def battle_1253(data, player):
    """docstring for battle"""
    request = mine_pb2.MineBattleRequest()
    request.ParseFromString(data)
    pos = request.pos                    # 矿所在位置
    line_up = request.lineup            # 阵容顺序
    red_best_skill_id = request.unparalleled # 无双编号
    blue_best_skill_id = 0
    blue_best_skill_level = 0
    red_units = {}
    blue_units = {}

    logger.debug("%s pos" % pos)

    mine_info = get_mine_info(player, pos)
    response = mine_pb2.MineBattleResponse()

    mine_type = mine_info.get("mine_type") # 根据矿所在位置判断pve or pvp
    print mine_type, "*"*80
    print request
    if mine_type == 0:
        # pve
        stage_id = mine_info.get("stage_id")        # todo: 根据pos获取关卡id
        stage_type = 5                              # 关卡类型
        stage_info = pve_process(stage_id, stage_type, line_up, 0, player)
        result = stage_info.get('result')
        response.res.result = result
        if not result:
            logger.info('进入关卡返回数据:%s', response)
            response.res.result_no = stage_info.get('result_no')
            return response.SerializePartialToString()
        red_units = stage_info.get('red_units')
        blue_units = stage_info.get('blue_units')
        blue_units = blue_units[0]
        process_mine_result(player, pos, response, result)

        print red_units, blue_units

    elif mine_type == 1:
        # pvp
        red_units = player.fight_cache_component.red_unit
        info = get_save_guard(player, pos)
        blue_units = info.get("battle_units")

        fight_result = pvp_process(player, line_up, red_units, blue_units, red_best_skill_id, info.get("best_skill_no"), info.get("level"))
        if fight_result:
            # 返回秘境的结果
            pass
        process_mine_result(player, pos, response, fight_result)

        blue_best_skill_id = info.get("best_skill_id")
        blue_best_skill_level = info.get("best_skill_level")

        print red_units, blue_units

    red_best_skill_no, red_best_skill_level = player.line_up_component.get_skill_info_by_unpar(red_best_skill_id)
    response.red_best_skill_id = red_best_skill_id
    response.red_best_skill_level = red_best_skill_level
    response.blue_best_skill_id = blue_best_skill_id
    response.blue_best_skill_level = blue_best_skill_level
    pvp_assemble_units(red_units, blue_units, response)
    print response, red_units, blue_units
    return response.SerializePartialToString()


def get_mine_info(player, pos):
    """根据pos获取关卡info.
    矿的类型：mine type 0/1
    如果野怪驻守的矿：关卡id
    玩家驻守的矿：
    """
    mine_info  = player.mine.get_info(pos)
    return mine_info

def get_save_guard(player, pos):
    """
    获取保存的驻守信息
    """
    info = player.mine.get_guard_info(pos)
    return info


def trigger_mine_boss():
    """
    触发秘境boss
    return {"result":True, "boss_id": boss_id}
    """
    boss_num = remote_gate['world'].get_boss_num()
    max_boss_num = base_config.get("warFogBossCriServer")
    if boss_num >= max_boss_num:
        return False

    result = remote_gate['world'].trigger_mine_boss()
    return result


@remoteserviceHandle('gate')
def trigger_mine_boss_1259(data, player):
    """
    仅供测试，触发秘境boss
    return {"result":True, "boss_id": boss_id}
    """
    boss_num = remote_gate['world'].mine_get_boss_num_remote()
    logger.debug("mine boss num: %s" % boss_num)
    max_boss_num = base_config.get("warFogBossCriServer")
    if boss_num >= max_boss_num:
        assert False, "mine boss reach max!"

    result = remote_gate['world'].trigger_mine_boss_remote()
    assert result, "trigger boss error!"

    response = common_pb2.CommonResponse()
    response.result = True
    return response.SerializePartialToString()

