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
remote_gate = GlobalObject().remote['gate']

def mine_status(player):
    """
    所有矿点状态
    """
    respone = mine_pb2.mineUpdate()
    respone.last_times = player.mine.reset_times
    mine_status = player.mine.mine_status()
    for mstatus in mine_status:
        one_mine = respone.mine.add()
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
    return respone

@remoteserviceHandle('gate')
def query_1240(data, player):
    """
    查询所有矿点信息
    """
    response = mine_status(player)
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def search_1241(data, player):
    """
    搜索矿点,ok
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.searchResponse()
    response.position = request.position
    if player.mine.can_search(request.position):
        player.mine.search_mine(request.position)
        player.mine.save_data()
        respone = mine_status(player)
        response.res.result = True
        response.mine = respone
    else:
        response.res.result = False
        response.res.result_no = 12410
        response.res.message = "此处已探索"
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
            mines = mine_status(player)
            response.res.result = True
            response.mine = mines
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
                mines = mine_status(player)
                response.res.result = True
                response.mine = mines
        
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def query_1243(data, player):
    """
    查看矿点详细信息
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    response = mine_pb2.mineDetail()
    response.position = request.positon
    detail_info = player.mine.detail_info(request.positon)
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

    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def guard_1244(data, player):
    """
    驻守矿点
    """
    pass

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
    request.ParseFromString(data)
    response = mine_pb2.drawStones()
    response.position = request.position
    stones = player.mine.harvest(request.position)
    response = add_stones(player, stones, response)
    return response


def battle(player, position):
    ret  = True
    return ret

@remoteserviceHandle('gate')
def battle_1246(data, player):
    """
    攻占矿点
    """
    request = mine_pb2.positionRequest()
    request.ParseFromString(data)
    ret = battle(player, request.position)
    if ret == True:
        settle = player.mine.settle(request.position)
    else:
        pass
    
    

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