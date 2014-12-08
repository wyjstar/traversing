# -*- coding:utf-8 -*-
'''
Created on 2014-11-24

@author: hack
'''
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import mine_pb2, item_response_pb2
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data.game_configs import shop_config, base_config
from app.game.core import item_group_helper
from app.game.core.drop_bag import BigBag
from shared.db_opear.configs_data.common_item import CommonGroupItem
from shared.utils.const import const
from app.game.component.character_line_up import CharacterLineUpComponent
from app.game.component.line_up.line_up_slot import LineUpSlotComponent
from app.game.component.line_up.equipment_slot import EquipmentSlotComponent
import cPickle
from app.game.action.node._fight_start_logic import save_line_up_order, pvp_assemble_response
from app.proto_file import pvp_rank_pb2
from app.battle.battle_process import BattlePVPProcess
from gfirefly.server.logobj import logger

remote_gate = GlobalObject().remote['gate']

def mine_status(player, response):
    """
    所有矿点状态
    """
    response.last_times = player.mine.reset_times
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
    return response

@remoteserviceHandle('gate')
def query_1240(data, player):
    """
    查询所有矿点信息
    """
    response = mine_pb2.mineUpdate()
    mine_status(player, response)
    print '1240-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def search_1241(data, player):
    """
    搜索矿点,ok
    """
    request = mine_pb2.positionRequest()
    #request.ParseFromString(data)
    request.position = 9
    response = mine_pb2.searchResponse()
    response.position = request.position
    if player.mine.can_search(request.position):
        player.mine.search_mine(request.position)
        mine_status(player, response.mine)
        response.res.result = True
    else:
        response.res.result = False
        response.res.result_no = 12410
        response.res.message = u"此处已探索"
    print '1241-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def reset_1242(data, player):
    """
    重置地图,ok
    """
    request  = mine_pb2.resetMap()
    request.ParseFromString(data)
    response  = mine_pb2.resetResponse()
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
    print '1242-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def query_1243(data, player):
    """
    查看矿点详细信息
    """
    request = mine_pb2.positionRequest()
    #request.ParseFromString(data)
    response = mine_pb2.mineDetail()
    request.position = 0
    response.position = request.position
    detail_info = player.mine.detail_info(request.position)
    ret, msg, last_increase, stones, heros = detail_info
    if ret == 0:
        response.res.result = True
        for sid, num in stones.items():
            one_type = response.stones.add()
            one_type.stone_id = sid
            one_type.stone_num = num
        response.increase = last_increase
        for hero_id in heros:
            one_hero = response.heros.add()
            one_hero.hid = hero_id
    else:
        response.res.result = False
        response.res.result_no = ret
        response.res.message = msg
    print '1243-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def guard_1244(data, player):
    """
    驻守矿点
    """
    request = mine_pb2.MineGuardRequest()
    request.ParseFromString(data)
    pos = request.pos  # 矿在地图上所在位置

    #构造阵容组件
    character_line_up = CharacterLineUpComponent(player)
    for slot in request.line_up_slots:
        line_up_slot = LineUpSlotComponent(player, slot.slot_no, activation=True, hero_no=slot.hero_no)

        for equipment_slot in slot.equipment_slots:
            equipment_slot = EquipmentSlotComponent(equipment_slot.slot_no, activation=True, equipment_id=slot.equipment_id)
            line_up_slot.equipment_slots[equipment_slot.slot_no] = equipment_slot

        character_line_up.line_up_slots[slot.slot_no] = line_up_slot

    battle_units = {} #需要保存的阵容信息
    for no, slot in character_line_up.line_up_slots.items():
        unit = slot.slot_attr
        if unit:
            battle_units[no] = unit

    info = {}
    info["battle_units"] = battle_units
    info["best_skill"] = 10001
    info["best_skill_level"] = 2
    info["level"] = player.level.level
    info["nickname"] = player.base_info.nickname
    info["character_id"] = player.base_info.id


    str_line_up_data = cPickle.dumps(info) #序列化的阵容信息
    print "*"*80, "battle units"
    print battle_units

def add_stones(player, stones, response):
    response.res.result = True
    for stone_id, num in stones.items():
        player.stone.add_stones(stone_id, num)
        one_type = response.stones.add()
        one_type.stone_id = stone_id
        one_type.stone_num = num
    player.stone.save_data()

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
    if stones:
        add_stones(player, stones, response)
    else:
        response.res.result = False
        response.res.result_no = 12450
        response.res.message = u"没有可以领取的符文石"
    print '1245-response', response
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def battle_1246(data, player):
    """
    攻占怪物驻守的矿点
    """
    return stage_start(data, player)

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
        response.res.message = "商人不存在"
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
    response = item_response_pb2.ItemUseResponse()
    if not player.mine.reward(request.position):
        response.res.result = False
        response.res.result_no = 12490
        response.res.message = u"已领取"
        return response.SerializePartialToString()
    player.mine.save_data()
    drop_id = base_config['warFogChest']
    add_items(player, response, [drop_id])
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
    consume_return_data = item_group_helper.consume(player, [price])  # 消耗
    item_group_helper.get_return(player, consume_return_data, response.consume)
    last_time = player.mine.acc_mine()
    player.mine.save_data()

    response.position = 0
    response.last_time = last_time
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def battle_1251(data, player):
    """
    攻占玩家驻守的矿点:pvp
    """
    request = pvp_rank_pb2.PvpFightRequest()
    request.ParseFromString(data)
    __skill = request.skill
    __best_skill, __skill_level = player.line_up_component.get_skill_info_by_unpar(__skill)
    save_line_up_order(request.lineup, player)

    record = {}
    #todo: 获取蓝方数据
    blue_units = record.get('units')
    # print "blue_units:", blue_units
    blue_units = cPickle.loads(blue_units)
    # print "blue_units:", blue_units
    red_units = player.fight_cache_component.red_unit
    process = BattlePVPProcess(red_units, __best_skill, player.level.level, blue_units,
                               record.get('best_skill', 0), record.get('level', 1))
    fight_result = process.process()

    logger.debug("fight result:%s" % fight_result)

    response = pvp_rank_pb2.PvpFightResponse()
    response.res.result = True
    pvp_assemble_response(red_units, blue_units, __best_skill, __skill_level,
            record.get("unpar_skill"), record.get("unpar_skill_level"), response)
    return response.SerializeToString()
