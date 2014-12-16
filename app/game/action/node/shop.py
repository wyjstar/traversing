# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from app.proto_file.shop_pb2 import RefreshShopItems, GetShopItems
from app.proto_file.shop_pb2 import GetShopItemsResponse
from shared.db_opear.configs_data.game_configs import shop_config
from shared.db_opear.configs_data.game_configs import shop_type_config
from app.game.core.item_group_helper import is_afford
# from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def lucky_draw_hero_501(pro_data, player):
    """抽取hero"""
    return shop_oper(pro_data, player)


@remoteserviceHandle('gate')
def lucky_draw_equipment_502(pro_data, player):
    """抽取equipment"""
    return shop_equipment_oper(pro_data, player)


@remoteserviceHandle('gate')
def buy_item_503(pro_data, player):
    """购买item"""
    return shop_oper(pro_data, player)


@remoteserviceHandle('gate')
def buy_gift_pack_504(pro_data, player):
    """购买礼包"""
    return shop_oper(pro_data, player)


def shop_oper(pro_data, player):
    """商城所有操作"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()

    shop_id = request.ids[0]
    shop_item = shop_config.get(shop_id)

    if not is_consume(player, shop_item):
        result = is_afford(player, shop_item.consume)  # 校验
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            response.res.message = u'消费不足！'
            return response.SerializeToString()

    player_type_shop = player.shop.get_shop_data(shop_item.get('type'))
    if not player_type_shop:
        response.res.result = False
        logger.error('no type shop:%s', shop_item.get('type'))
        return response.SerializeToString()

    shop_type_item = shop_type_config.get(shop_item.get('type'))
    # 消耗
    return_data = consume(player, shop_item.consume,
                          player_type_shop, shop_type_item)
    get_return(player, return_data, response.consume)

    return_data = gain(player, shop_item.gain)  # 获取
    extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

    get_return(player, return_data, response.gain)
    get_return(player, extra_return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


def shop_equipment_oper(pro_data, player):
    """装备抽取"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()

    shop_id = request.ids[0]
    shop_num = request.num
    shop_item = shop_config.get(shop_id)

    if shop_num == 1:  # and not is_consume(player, shop_item):
        # 免费抽取
        return_data = gain(player, shop_item.gain)  # 获取
        extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

        get_return(player, return_data, response.gain)
        get_return(player, extra_return_data, response.gain)
    # 多装备抽取
    elif shop_num >= 1:
        for i in range(shop_num):
            result = is_afford(player, shop_item.consume)  # 校验
            if not result.get('result'):
                response.res.result = False
                response.res.result_no = 101
                return response.SerializePartialToString()

        for i in range(shop_num):
            return_data = consume(player, shop_item.consume)  # 消耗
            get_return(player, return_data, response.consume)

        for i in range(shop_num):
            return_data = gain(player, shop_item.gain)  # 获取
            extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

            get_return(player, return_data, response.gain)
            get_return(player, extra_return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def shop_buy_505(pro_data, player):
    """商店"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()
    common_response = response.res

    for shop_id in request.ids:
        logger.info("shop id:%s", shop_id)
        shop_item = shop_config.get(shop_id)
        if not shop_item:
            common_response.result = False
            common_response.result_no = 911
            logger.error('error shop id:%s', shop_id)
            return response.SerializeToString()

        shop = player.shop.get_shop_data(shop_item.get('type'))

        result = is_afford(player, shop_item.consume)  # 校验
        if not result.get('result'):
            common_response.result = False
            common_response.result_no = result.get('result_no')
            common_response.message = u'消费不足！'
            logger.error('not enough money')
            return response.SerializeToString()

        if shop_id in shop['item_ids']:
            shop['item_ids'].remove(shop_id)
            shop['buyed_item_ids'].append(shop_id)
            player.shop.save_data()
        else:
            logger.error("can not find shop id:%s:%s",
                         shop_id, shop['item_ids'])
            common_response.result = False
            common_response.result_no = 501
            return response.SerializeToString()

        shop_type_item = shop_type_config.get(shop_item.get('type'))
        consume_return_data = consume(player, shop_item.consume,
                                      shop, shop_type_item)  # 消耗

        return_data = gain(player, shop_item.gain)  # 获取
        get_return(player, consume_return_data, response.consume)
        get_return(player, return_data, response.gain)

    common_response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_shop_items_507(pro_data, player):
    """刷新商品列表"""
    request = RefreshShopItems()
    request.ParseFromString(pro_data)
    shop_type = request.shop_type

    response = GetShopItemsResponse()
    # max_shop_refresh_times = player.vip_component.shop_refresh_times

    # cancel vip temprory
    # if max_shop_refresh_times <= player.soul_shop.refresh_times:
    # logger.debug("already reach refresh max!")
    #     response.res.result = False
    #     response.res.result_no = 501
    #     return response.SerializePartialToString()

    response.res.result = player.shop.refresh_price(shop_type)
    if not response.res.result:
        logger.debug("gold not enough!")
        response.res.result = False
        response.res.result_no = 101
        return response.SerializePartialToString()

    shopdata = player.shop.get_shop_data(shop_type)
    if not shopdata:
        response.res.result = False
        return response.SerializePartialToString()

    for x in shopdata['item_ids']:
        response.id.append(x)
    for x in shopdata['buyed_item_ids']:
        response.buyed_id.append(x)

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_shop_items_508(pro_data, player):
    """获取商品列表"""
    request = GetShopItems()
    request.ParseFromString(pro_data)
    shop_type = request.shop_type

    response = GetShopItemsResponse()
    shopdata = player.shop.get_shop_data(shop_type)

    if not shopdata:
        response.res.result = False
        return response.SerializePartialToString()

    for x in shopdata['item_ids']:
        response.id.append(x)
    for x in shopdata['buyed_item_ids']:
        response.buyed_id.append(x)

    logger.debug("getshop items:%s:%s", shop_type, shopdata['item_ids'])
    response.luck_num = int(shopdata['luck_num'])
    response.res.result = True
    return response.SerializePartialToString()
