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


@have_player
def soul_shop(dynamic_id, pro_data, **kwargs):
    player = kwargs.get('player')
    request = SoulShopRequest()
    request.ParseFromString(pro_data)
    response = SoulShopResponse()
    common_response = response.res
    shop_id = request.id

    shop_item = soul_shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.message = '消费不足！'

    consume(player, shop_item.consume)  # 消耗

    return_data = gain(player, shop_item.gain)  # 获取
    extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    get_return(player, return_data, response)
    get_return(player, extra_return_data, response)
    common_response.result = True
    return response.SerializeToString()


@have_player
def get_shop_items(dynamic_id, **kwargs):
    ids = get_shop_item_ids()
    shop = GetShopItemsResponse()
    for x in ids:
        shop.id.append(x)
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
    item_num = base_config.get('soul_shop_item_num')
    return random_multi_pick_without_repeat(items, item_num)

