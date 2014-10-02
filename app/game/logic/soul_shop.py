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
from gtwisted.utils import log


@have_player
def soul_shop(dynamic_id, pro_data, **kwargs):
    player = kwargs.get('player')
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
    #extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    get_return(player, consume_return_data, response.consume)
    get_return(player, return_data, response.gain)
    #get_return(player, extra_return_data, response)
    common_response.result = True
    return response.SerializeToString()


@have_player
def get_shop_items(dynamic_id, **kwargs):

    player = kwargs.get('player')
    shop = GetShopItemsResponse()
    max_shop_refresh_times = player.vip_component.shop_refresh_times
    prize = base_config.get('soulShopRefreshPrice').get('2')[0]

    # cancel vip temprory
    # if max_shop_refresh_times <= player.soul_shop_refresh_times:
    #     log.DEBUG("already reach refresh max!")
    #     shop.res.result = False
    #     shop.res.result_no = 501
    #     return shop.SerializePartialToString()

    if player.soul_shop_refresh_times != 0:
        prize = 2 * prize

    if player.finance.gold < prize:
        log.DEBUG("gold not enough!")
        shop.res.result = False
        shop.res.result_no = 101
        return shop.SerializePartialToString()


    ids = get_shop_item_ids()
    player.soul_shop_refresh_times += 1
    player.save_data()

    player.finance.gold -= prize
    player.finance.save_data()


    print "soul ids:", ids
    for x in ids:
        shop.id.append(x)

    shop.res.result = True
    return shop.SerializeToString()


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

