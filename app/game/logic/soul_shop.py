# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:35.
"""
from app.game.logic.common.check import have_player
from app.proto_file.soul_shop_pb2 import SoulShopRequest, GetShopItemsResponse, SoulShopResponse
from shared.db_opear.configs_data.game_configs import soul_shop_config
from app.game.logic.item_group_helper import is_afford, consume, gain, get_return
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils.random_pick import random_multi_pick_without_repeat
from gfirefly.server.logobj import logger
import time


@have_player
def soul_shop(pro_data, player):
    request = SoulShopRequest()
    request.ParseFromString(pro_data)
    response = SoulShopResponse()
    common_response = response.res
    shop_id = request.id

    print "soul shop id:", shop_id
    shop_item = soul_shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.result_no = result.get('result_no')
        common_response.message = u'消费不足！'

    consume_return_data = consume(player, shop_item.consume)  # 消耗

    return_data = gain(player, shop_item.gain)  # 获取
    # extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    get_return(player, consume_return_data, response.consume)
    get_return(player, return_data, response.gain)
    #get_return(player, extra_return_data, response)

    try:
        player.soul_shop.item_ids.remove(shop_id)
        player.soul_shop.save_data()
    except Exception:
        logger.debug("can not find shop id:" + str(shop_id)+str(player.soul_shop.item_ids))
        common_response.result = False
        common_response.result_no = 501
        return response.SerializeToString()

    common_response.result = True
    return response.SerializeToString()


@have_player
def refresh_shop_items(player):
    """刷新"""
    shop = GetShopItemsResponse()
    max_shop_refresh_times = player.vip_component.shop_refresh_times

    # cancel vip temprory
    # if max_shop_refresh_times <= player.soul_shop.refresh_times:
    # logger.debug("already reach refresh max!")
    #     shop.res.result = False
    #     shop.res.result_no = 501
    #     return shop.SerializePartialToString()

    price = player.soul_shop.price
    if player.finance.gold < price:
        logger.debug("gold not enough!")
        shop.res.result = False
        shop.res.result_no = 101
        return shop.SerializePartialToString()

    ids = get_shop_item_ids()
    player.soul_shop.refresh_times += 1
    player.soul_shop.last_refresh_time = int(time.time())
    player.soul_shop.save_data()

    player.finance.gold -= price
    logger.debug("refresh price:"+str(price))
    player.finance.save_data()

    logger.debug("soul ids:" + str(ids))

    for x in ids:
        shop.id.append(x)
    # save soul shop item ids
    player.soul_shop.item_ids = ids
    player.soul_shop.save_data()

    shop.res.result = True
    return shop.SerializeToString()


@have_player
def get_shop_items(player):
    """获取商品列表"""
    shop = GetShopItemsResponse()
    logger.debug("get_shop_items1")
    item_ids = player.soul_shop.item_ids

    for x in item_ids:
        shop.id.append(x)

    logger.debug("get_shop_items2"+str(item_ids))
    shop.res.result = True
    return shop.SerializePartialToString()


def init_soul_shop_items(player):
    """
    init shop items when create character
    """
    player.soul_shop.item_ids = get_shop_item_ids()
    player.soul_shop.save_data()


def get_all_shop_items():
    """从配置文件中读取所有商品"""
    data = {}
    for item_id, item in soul_shop_config.items():
        data[item_id] = item.weight
    return data


def get_shop_item_ids():
    """随机筛选ids"""
    items = get_all_shop_items()
    item_num = base_config.get('soulShopItemNum')
    return random_multi_pick_without_repeat(items, item_num)
