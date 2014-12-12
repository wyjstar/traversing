# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午8:33.
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.shop_pb2 import ShopResponse, RefreshShopItems
from shared.db_opear.configs_data.game_configs import shop_config
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def soul_shop_506_(pro_data, player):
    """武魂商店"""
    request = None  # SoulShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()
    common_response = response.res
    shop_id = request.id
    shop_type = request.shop_type

    logger.info("shop id:%s", shop_id)
    shop_item = shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.result_no = result.get('result_no')
        common_response.message = u'消费不足！'

    consume_return_data = consume(player, shop_item.consume)  # 消耗

    return_data = gain(player, shop_item.gain)  # 获取
    get_return(player, consume_return_data, response.consume)
    get_return(player, return_data, response.gain)

    shop = player.shop.get_shop_data(shop_type)

    if shop_id in shop.item_ids:
        shop.item_ids.remove(shop_id)
        player.shop.save_data()
    else:
        logger.debug("can not find shop id:%d:%d", shop_id,
                     player.soul_shop.item_ids)
        common_response.result = False
        common_response.result_no = 501
        return response.SerializeToString()

    common_response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_shop_items_507_(pro_data, player):
    """刷新商品列表"""
    request = RefreshShopItems()
    request.ParseFromString(pro_data)
    shop_type = request.shop_type

    response = None  # GetShopItemsResponse()
    # max_shop_refresh_times = player.vip_component.shop_refresh_times

    # cancel vip temprory
    # if max_shop_refresh_times <= player.soul_shop.refresh_times:
    # logger.debug("already reach refresh max!")
    #     response.res.result = False
    #     response.res.result_no = 501
    #     return response.SerializePartialToString()

    price = player.shop.price
    if player.finance.gold < price:
        logger.debug("gold not enough!")
        response.res.result = False
        response.res.result_no = 101
        return response.SerializePartialToString()

    response.res.result = player.shop.refresh_items(shop_type)
    if response.res.result:
        player.finance.gold -= price
        logger.debug("refresh price:" + str(price))

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_shop_items_508_(pro_data, player):
    """获取商品列表"""
    response = None  # GetShopItemsResponse()
    logger.debug("get_shop_items1")
    item_ids = player.shop.item_ids

    for x in item_ids:
        response.id.append(x)

    logger.debug("get_shop_items2"+str(item_ids))
    response.res.result = True
    return response.SerializePartialToString()
