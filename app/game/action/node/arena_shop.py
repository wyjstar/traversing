# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午8:33.
"""

from app.game.core import item_group_helper
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from app.proto_file import arena_shop_pb2
from shared.db_opear.configs_data.game_configs import arena_shop_config
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils.random_pick import random_multi_pick_without_repeat
import time


@remoteserviceHandle('gate')
def arene_shop_1510(pro_data, player):
    """武魂商店"""
    request = arena_shop_pb2.ArenaShopRequest()
    request.ParseFromString(pro_data)
    response = arena_shop_pb2.ArenaShopResponse()
    common_response = response.res
    shop_id = request.id

    print "arena shop id:", shop_id
    shop_item = arena_shop_config.get(shop_id)
    result = item_group_helper.is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.result_no = result.get('result_no')
        common_response.message = u'消费不足！'

    consume_return_data = item_group_helper.consume(player, shop_item.item_group_helper.consume)  # 消耗

    return_data = item_group_helper.gain(player, shop_item.gain)  # 获取
    # extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    item_group_helper.get_return(player, consume_return_data, response.consume)
    item_group_helper.get_return(player, return_data, response.gain)
    # get_return(player, extra_return_data, response)

    try:
        player.arena_shop.item_ids.remove(shop_id)
        player.arena_shop.save_data()
    except Exception:
        logger.debug("can not find shop id:" +
                     str(shop_id)+str(player.arena_shop.item_ids))
        common_response.result = False
        common_response.result_no = 501
        return response.SerializeToString()

    common_response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_shop_items_1511(player):
    """刷新商品列表"""
    shop = arena_shop_pb2.ArenaGetShopItemsResponse()
    # max_shop_refresh_times = player.vip_component.shop_refresh_times

    # cancel vip temprory
    # if max_shop_refresh_times <= player.arena_shop.refresh_times:
    # logger.debug("already reach refresh max!")
    #     shop.res.result = False
    #     shop.res.result_no = 501
    #     return shop.SerializePartialToString()

    price = player.arena_shop.price
    if player.finance.gold < price:
        logger.debug("gold not enough!")
        shop.res.result = False
        shop.res.result_no = 101
        return shop.SerializePartialToString()

    ids = get_shop_item_ids()
    player.arena_shop.refresh_times += 1
    player.arena_shop.last_refresh_time = int(time.time())
    player.arena_shop.save_data()

    player.finance.gold -= price
    logger.debug("refresh price:"+str(price))
    player.finance.save_data()

    logger.debug("arena ids:" + str(ids))

    for x in ids:
        shop.id.append(x)
    # save arena shop item ids
    player.arena_shop.item_ids = ids
    player.arena_shop.save_data()

    shop.res.result = True
    return shop.SerializeToString()


@remoteserviceHandle('gate')
def get_shop_items_1512(player):
    """获取商品列表"""
    shop = arena_shop_pb2.ArenaGetShopItemsResponse()
    logger.debug("get_shop_items1")
    item_ids = player.arena_shop.item_ids

    for x in item_ids:
        shop.id.append(x)

    logger.debug("get_shop_items2"+str(item_ids))
    shop.res.result = True
    return shop.SerializePartialToString()


def init_arena_shop_items(player):
    """
    init shop items when create character
    """
    player.arena_shop.item_ids = get_shop_item_ids()
    player.arena_shop.save_data()


def get_all_shop_items():
    """从配置文件中读取所有商品"""
    data = {}
    for item_id, item in arena_shop_config.items():
        data[item_id] = item.weight
    return data


def get_shop_item_ids():
    """随机筛选ids"""
    items = get_all_shop_items()
    item_num = base_config.get('arena_shop_item_num')
    print 'arena_shop_item_num', item_num
    return random_multi_pick_without_repeat(items, item_num)
