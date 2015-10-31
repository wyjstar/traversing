# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from shared.db_opear.configs_data.common_item import CommonGroupItem
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from app.proto_file.shop_pb2 import RefreshShopItems, GetShopItems
from app.proto_file.shop_pb2 import GetShopItemsResponse
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import is_afford
# from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import get_consume_gold_num
from gfirefly.server.logobj import logger
from shared.utils.const import const
from shared.tlog import tlog_action
import copy
from app.game.core.task import hook_task, CONDITIONId


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
    shop_item = game_configs.shop_config.get(shop_id)
    # logger.debug(shop_id)
    # logger.debug("---------")

    if shop_id == 10001 and player.shop.first_coin_draw:
        is_consume(player, shop_item)

        card_draw = game_configs.base_config.get("CoinCardFirst")
        return_data = gain(player, card_draw, reason)  # 获取
        get_return(player, return_data, response.gain)
        player.shop.single_coin_draw_times += 1
        player.shop.first_coin_draw = False
        player.shop.save_data()

        hook_task(player, CONDITIONId.HERO_GET_LIANG, 1)

        response.res.result = True
        return response.SerializeToString()

    if shop_id == 50001 and player.shop.first_gold_draw:
        is_consume(player, shop_item)

        card_draw = game_configs.base_config.get("CardFirst")
        return_data = gain(player, card_draw, reason)  # 获取
        get_return(player, return_data, response.gain)
        player.shop.first_gold_draw = False
        player.shop.single_gold_draw_times += 1
        player.shop.save_data()

        hook_task(player, CONDITIONId.HERO_GET, 1)

        response.res.result = True
        return response.SerializeToString()

    _is_consume_result = is_consume(player, shop_item)
    price = shop_item.consume
    if _is_consume_result:
        result = is_afford(player, price)  # 校验
        if not result.get('result'):
            if not shop_item.alternativeConsume:
                logger.error('shop oper is not enough consume')
                response.res.result = False
                response.res.result_no = result.get('result_no')
                response.res.message = u'消费不足！'
                return response.SerializeToString()
            else:
                price = shop_item.alternativeConsume
                result = is_afford(player, price)
                if not result.get('result'):
                    response.res.result = False
                    response.res.result_no = result.get('result_no')
                    response.res.message = u'消费不足2！'
                    return response.SerializeToString()

    player_type_shop = player.shop.get_shop_data(shop_item.get('type'))
    if not player_type_shop:
        response.res.result = False
        logger.error('no type shop:%s', shop_item.get('type'))
        return response.SerializeToString()

    shop_type_item = game_configs.shop_type_config.get(shop_item.get('type'))
    # 消耗

    need_gold = get_consume_gold_num(price)
    if not _is_consume_result:
        need_gold = 0

    def func():
        # consume_data = []
        if _is_consume_result:
            return_data = consume(player, price,
                                  player_type_shop, reason, shop_type_item)
            get_return(player, return_data, response.consume)
            # consume_data = return_data
        # logger.debug("hero-draw2")
        return_data = []
        extra_return_data = []
        CoinCardCumulateTimes = game_configs.base_config.get("CoinCardCumulateTimes", 0)
        CardCumulateTimes = game_configs.base_config.get("CardCumulateTimes", 0)
        if shop_item.type == 5:
            # todo: 如何判断shop类型：单抽、十连抽
            # logger.debug("hero_draw: shop_item_id %s, item_no %s" % (shop_item.id, shop_item.gain[0].item_no))
            gain_items = player.shop.get_draw_drop_bag(shop_item.gain[0].item_no)
            if shop_item.id == 50001:
                # 单抽达到指定次数，获得指定武将
                player.shop.single_gold_draw_times += 1
                if player.shop.single_gold_draw_times == CardCumulateTimes:
                    gain_items = game_configs.base_config.get("CardCumulate", [])
                    player.shop.single_gold_draw_times = 0
                    logger.debug("tenth gold draw %s %s" % (player.shop.single_gold_draw_times, gain_items))

            player.shop.save_data()
            return_data = gain(player, gain_items, reason)
            extra_return_data = gain(player, shop_item.extraGain, reason)  # 额外获取

            get_return(player, return_data, response.gain)
            get_return(player, extra_return_data, response.gain)
            if shop_item.id == 50001:
                hook_task(player, CONDITIONId.HERO_GET, 1)
            else:
                hook_task(player, CONDITIONId.HERO_GET, 10)
        else:
            gain_items = shop_item.gain
            if shop_item.id == 10001:
                # 单抽达到指定次数，获得指定武将
                player.shop.single_coin_draw_times += 1
                if player.shop.single_coin_draw_times == CoinCardCumulateTimes:
                    gain_items = game_configs.base_config.get("CoinCardCumulate", [])
                    player.shop.single_coin_draw_times = 0
                    logger.debug("tenth coin draw %s %s" % (player.shop.single_coin_draw_times, gain_items))

            player.shop.save_data()
            return_data = gain(player, gain_items, reason)  # 获取
            extra_return_data = gain(player, shop_item.extraGain, reason)  # 额外获取

            get_return(player, return_data, response.gain)
            get_return(player, extra_return_data, response.gain)
            if shop_item.id == 10001:
                hook_task(player, CONDITIONId.HERO_GET_LIANG, 1)
            else:
                hook_task(player, CONDITIONId.HERO_GET_LIANG, 10)

        send_tlog(player, shop_item)

    player.pay.pay(need_gold, reason, func)

    response.res.result = True
    logger.debug("response gain %s" % response.gain)
    return response.SerializeToString()


def send_tlog(player, shop_item):
        item_type = shop_item.gain[0].item_type
        item_id = shop_item.gain[0].item_no
        count = shop_item.gain[0].num
        money = shop_item.consume[0].num
        money_type = shop_item.consume[0].item_no
        discount_money = 0
        discount_money_type = 0
        is_discount = 0
        if shop_item.discountPrice:
            is_discount = 1
            discount_money = shop_item.discountPrice[0].num
            discount_money_type = shop_item.discountPrice[0].item_no
        limit_vip_everyday = []
        if shop_item.limitVIPeveryday:
            for i in range(30):
                if shop_item.limitVIPeveryday.get(i):
                    limit_vip_everyday.append(shop_item.limitVIPeveryday.get(i))
        limit_vip = []
        if shop_item.limitVIP:
            for i in range(30):
                if shop_item.limitVIP.get(i):
                    limit_vip.append(shop_item.limitVIP.get(i))

        tlog_action.log('ItemMoneyFlow', player, item_type, item_id, count,
                        money, money_type, discount_money, discount_money_type,
                        '', '', is_discount)
        # tlog_action.log('ItemMoneyFlow', player, item_type, item_id, count,
        #                 money, money_type, discount_money, discount_money_type,
        #                 str(limit_vip_everyday), str(limit_vip), is_discount)


def shop_equipment_oper(pro_data, player):
    """装备抽取"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()

    shop_id = request.ids[0]
    shop_num = request.num
    shop_item = game_configs.shop_config.get(shop_id)

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
            return_data = consume(player, shop_item.consume, const.SHOP_DRAW_EQUIPMENT)  # 消耗
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
        shop_item = game_configs.shop_config.get(shop_id)
        if not shop_item:
            common_response.result = False
            common_response.result_no = 911
            logger.error('error shop id:%s', shop_id)
            return response.SerializeToString()

        shop = player.shop.get_shop_data(shop_item.get('type'))

        price = shop_item.consume if not shop_item.discountPrice else shop_item.discountPrice
        result = is_afford(player, price, multiple=item_count)  # 校验
        if not result.get('result'):
            logger.error('not enough money:%s', price)
            if not shop_item.alternativeConsume:
                common_response.result = False
                common_response.result_no = result.get('result_no')
                common_response.message = u'消费不足！'
                return response.SerializeToString()
            else:
                price = shop_item.alternativeConsume
                result = is_afford(player, price, multiple=item_count)
                if not result.get('result'):
                    common_response.result = False
                    common_response.result_no = result.get('result_no')
                    common_response.message = u'消费不足2！'
                    return response.SerializeToString()

        if shop_item.limitVIP:
            limit_num = shop_item.limitVIP.get(player.base_info.vip_level, 0)
            shop_id_buyed_num = shop['vip_limit_items'].get(shop_id, 0)

            if shop_id_buyed_num + item_count > limit_num:
                logger.error("vip limit shop item:%s:%s limit:%s:%s",
                             shop_id, item_count, shop_id_buyed_num, limit_num)
                common_response.result = False
                common_response.result_no = 502
                response.limit_item_current_num = shop_id_buyed_num
                response.limit_item_max_num = limit_num
                return response.SerializeToString()
            shop['vip_limit_items'][shop_id] = shop_id_buyed_num + item_count

        if shop_item.limitVIPeveryday:
            limit_num = shop_item.limitVIPeveryday.get(player.base_info.vip_level, 0)
            shop_id_buyed_num = shop['limit_items'].get(shop_id, 0)

            if shop_id_buyed_num + item_count > limit_num:
                logger.error("limit shop item:%s:%s limit:%s:%s",
                             shop_id, item_count, shop_id_buyed_num, limit_num)
                common_response.result = False
                common_response.result_no = 502
                response.limit_item_current_num = shop_id_buyed_num
                response.limit_item_max_num = limit_num
                return response.SerializeToString()
            shop['limit_items'][shop_id] = shop_id_buyed_num + item_count

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

        shop_type_item = game_configs.shop_type_config.get(shop_item.get('type'))

        need_gold = get_consume_gold_num(price, item_count)

        _lucky_attr = 0
        shop_item_attr = shop_item.get('attr')
        # print 'luck attr', shop_item_attr
        if shop_item_attr:
            lucky_keys = sorted(shop_item_attr.keys())
            for k in lucky_keys:
                # print k, shop_item_attr[k]
                if shop['luck_num'] >= k:
                    _lucky_attr = shop_item_attr[k]
                    # print 'luck Num attr', shop['luck_num'], shop_item_attr[k], shop_item_attr
                else:
                    break

        def func():
            consume_return_data = consume(player, price,
                                          get_reason(shop_item.get('type')),
                                          multiple=item_count,
                                          shop=shop,
                                          luck_config=shop_type_item)  # 消耗
            return_data = gain(player,
                               shop_item.gain,
                               get_reason(shop_item.get('type')),
                               multiple=item_count,
                               lucky_attr_id=_lucky_attr)  # 获取
            get_return(player, consume_return_data, response.consume)
            get_return(player, return_data, response.gain)
            for _ in range(item_count):
                send_tlog(player, shop_item)
            logger.debug("allBuyRefresh %s" % shop_type_item.allBuyRefresh)
            if not shop['item_ids'] and shop_type_item.allBuyRefresh:
                logger.debug("shop auto refresh =============")
                player.shop.auto_refresh_items(shop_item.get('type'))
                response.is_all_buy = True

        player.pay.pay(need_gold, get_reason(shop_item.get('type')), func)

    player.shop.save_data()
    common_response.result = True
    return response.SerializeToString()

REASON_HASH = {3: const.COMMON_BUY_ITEM,
               4: const.COMMON_BUY_GIFT,
               7: const.COMMON_BUY_MINE,
               8: const.COMMON_BUY_HERO_SOUL,
               9: const.COMMON_BUY_PVP,
               11: const.COMMON_BUY_MELT,
               12: const.COMMON_BUY_EQUIPMENT}


def get_reason(shop_type):
    if shop_type in REASON_HASH:
        return REASON_HASH[shop_type]
    return const.COMMON_BUY


@remoteserviceHandle('gate')
def refresh_shop_items_507(pro_data, player):
    """刷新商品列表"""
    request = RefreshShopItems()
    request.ParseFromString(pro_data)
    shop_type = request.shop_type

    response = GetShopItemsResponse()
    if not player.shop.check_shop_refresh_times(shop_type):
        logger.debug("already reach refresh max!")
        response.res.result = False
        response.res.result_no = 50701
        return response.SerializePartialToString()

    response.res.result = player.shop.refresh_price(shop_type, response)
    if not response.res.result:
        logger.debug("gold not enough!")
        response.res.result = False
        response.res.result_no = 50702
        return response.SerializePartialToString()

    shopdata = player.shop.get_shop_data(shop_type)
    if not shopdata:
        response.res.result = False
        return response.SerializePartialToString()

    for x in shopdata['item_ids']:
        response.id.append(x)
    for x in shopdata['buyed_item_ids']:
        response.buyed_id.append(x)
    for k, v in shopdata['limit_items']:
        response.limit_item_id.append(k)
        response.limit_item_num.append(v)

    if shop_type == 11:
        # 11活动
        act_confs = game_configs.activity_config.get(23, [])
        is_open = 0
        for act_conf in act_confs:
            if player.base_info.is_activiy_open(act_conf.id):
                is_open = 1
                break
        if is_open:
            player.act.add_act23_times()
            player.act.save_data()

    response.luck_num = int(shopdata['luck_num'])
    logger.debug("response %s", response)
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
    for k, v in shopdata['limit_items'].items():
        response.limit_item_id.append(k)
        response.limit_item_num.append(v)
    for k, v in shopdata['vip_limit_items'].items():
        vim_limit_item = response.vip_limit_item.add()
        vim_limit_item.item_id = k
        vim_limit_item.item_num = v

    # logger.debug("getshop items:%s:%s", shop_type, shopdata['item_ids'])
    response.luck_num = int(shopdata['luck_num'])
    response.res.result = True
    response.refresh_times = shopdata['refresh_times']
    return response.SerializePartialToString()
