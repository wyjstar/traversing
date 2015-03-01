# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from shared.db_opear.configs_data.common_item import CommonGroupItem
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from app.proto_file.shop_pb2 import RefreshShopItems, GetShopItems
from app.proto_file.shop_pb2 import GetShopItemsResponse
from shared.db_opear.configs_data.game_configs import shop_config, base_config
from shared.db_opear.configs_data.game_configs import shop_type_config
from app.game.core.item_group_helper import is_afford
# from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from gfirefly.server.logobj import logger
from shared.utils.const import const


@remoteserviceHandle('gate')
def lucky_draw_hero_501(pro_data, player):
    """抽取hero"""
    return shop_oper(pro_data, player, const.SHOP_DRAW_HERO)


@remoteserviceHandle('gate')
def lucky_draw_equipment_502(pro_data, player):
    """抽取equipment"""
    return shop_equipment_oper(pro_data, player)


@remoteserviceHandle('gate')
def buy_item_503(pro_data, player):
    """购买item"""
    return shop_oper(pro_data, player, const.SHOP_BUY_ITEM)


@remoteserviceHandle('gate')
def buy_gift_pack_504(pro_data, player):
    """购买礼包"""
    return shop_oper(pro_data, player, const.SHOP_BUY_GIFT_PACK)


def shop_oper(pro_data, player, reason):
    """商城所有操作"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()
    shop_id = request.ids[0]
    shop_item = shop_config.get(shop_id)
    logger.debug(shop_id)
    logger.debug("---------")

    print shop_id, player.shop.first_coin_draw, player.shop.first_gold_draw, 'shop_id  '*10
    if shop_id == 10001 and player.shop.first_coin_draw:
        is_consume(player, shop_item)

        card_draw = base_config.get("CoinCardFirst")
        return_data = gain(player, card_draw, reason)  # 获取
        get_return(player, return_data, response.gain)
        player.shop.first_coin_draw = False
        player.shop.save_data()

        response.res.result = True
        return response.SerializeToString()

    if shop_id == 50001 and player.shop.first_gold_draw:
        is_consume(player, shop_item)

        card_draw = base_config.get("CardFirst")
        return_data = gain(player, card_draw, reason)  # 获取
        get_return(player, return_data, response.gain)
        player.shop.first_gold_draw = False
        player.shop.save_data()

        response.res.result = True
        return response.SerializeToString()

    _is_consume_result = is_consume(player, shop_item)
    if _is_consume_result:
        result = is_afford(player, shop_item.consume)  # 校验
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            response.res.message = u'消费不足！'
            logger.error('shop oper is not enough gold')
            return response.SerializeToString()

    player_type_shop = player.shop.get_shop_data(shop_item.get('type'))
    if not player_type_shop:
        response.res.result = False
        logger.error('no type shop:%s', shop_item.get('type'))
        return response.SerializeToString()

    shop_type_item = shop_type_config.get(shop_item.get('type'))
    # 消耗
    if _is_consume_result:
        return_data = consume(player, shop_item.consume,
                              player_type_shop, shop_type_item)
        get_return(player, return_data, response.consume)

    return_data = gain(player, shop_item.gain, reason)  # 获取
    extra_return_data = gain(player, shop_item.extraGain, reason)  # 额外获取

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
        return_data = gain(player, shop_item.gain, const.SHOP_DRAW_EQUIPMENT)  # 获取
        extra_return_data = gain(player, shop_item.extraGain, const.SHOP_DRAW_EQUIPMENT)  # 额外获取

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
            return_data = gain(player, shop_item.gain, const.SHOP_DRAW_EQUIPMENT)  # 获取
            extra_return_data = gain(player, shop_item.extraGain, const.SHOP_DRAW_EQUIPMENT)  # 额外获取

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

    if len(request.ids) != len(request.item_count):
        shop_items = dict(zip(request.ids, [1]*len(request.ids)))
    else:
        shop_items = dict(zip(request.ids, request.item_count))
    # shop_items = {}
    # shop_items[request.ids[0]] = 2
    for shop_id, item_count in shop_items.items():
        logger.info("shop id:%s", shop_id)
        shop_item = shop_config.get(shop_id)
        if not shop_item:
            common_response.result = False
            common_response.result_no = 911
            logger.error('error shop id:%s', shop_id)
            return response.SerializeToString()

        shop = player.shop.get_shop_data(shop_item.get('type'))

        price = shop_item.consume if not shop_item.discountPrice else shop_item.discountPrice
        result = is_afford(player, price, multiple=item_count)  # 校验
        if not result.get('result'):
            common_response.result = False
            common_response.result_no = result.get('result_no')
            common_response.message = u'消费不足！'
            logger.error('not enough money:%s', price)
            return response.SerializeToString()

        if shop_item.batch == 1:
            if shop_id in shop['item_ids']:
                shop['item_ids'].remove(shop_id)
                shop['buyed_item_ids'].append(shop_id)
            else:
                logger.error("can not find shop id:%s:%s",
                             shop_id, shop['item_ids'])
                common_response.result = False
                common_response.result_no = 501
                return response.SerializeToString()

        shop_type_item = shop_type_config.get(shop_item.get('type'))

        consume_return_data = consume(player, price,
                                      multiple=item_count,
                                      shop=shop,
                                      luck_config=shop_type_item)  # 消耗
        return_data = gain(player, shop_item.gain, const.COMMON_BUY, multiple=item_count)  # 获取

        get_return(player, consume_return_data, response.consume)
        get_return(player, return_data, response.gain)

    player.shop.save_data()
    common_response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def refresh_shop_items_507(pro_data, player):
    """刷新商品列表"""
    request = RefreshShopItems()
    request.ParseFromString(pro_data)
    shop_type = request.shop_type

    response = GetShopItemsResponse()
    # max_shop_refresh_times = player.base_info.shop_refresh_times

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

    response.luck_num = int(shopdata['luck_num'])
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
    response.refresh_times = shopdata['refresh_times']
    return response.SerializePartialToString()
