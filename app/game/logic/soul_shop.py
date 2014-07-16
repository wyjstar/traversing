# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:35.
"""
from app.game.logic.common.check import have_player
from app.proto_file.soul_shop_pb2 import SoulShopRequest, GetShopItemsResponse
from shared.db_opear.configs_data.game_configs import soul_shop_config
from app.game.logic.item_group_helper import is_afford, consume, gain, get_return
from app.proto_file.player_response_pb2 import GameResourcesResponse
from app.game.core.soul_shop import get_shop_item_ids


@have_player
def soul_shop(dynamic_id, pro_data, **kwargs):
    player = kwargs.get('player')
    request = SoulShopRequest()
    request.ParseFromString(pro_data)
    game_resources_response = GameResourcesResponse()
    common_response = game_resources_response.res
    shop_id = request.id

    shop_item = soul_shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        common_response.result = False
        common_response.message = '消费不足！'

    consume(player, shop_item.consume)  # 消耗

    return_data = gain(player, shop_item.gain)  # 获取
    extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取
    get_return(player, return_data, game_resources_response)
    get_return(player, extra_return_data, game_resources_response)
    common_response.result = True
    return game_resources_response.SerializeToString()


@have_player
def get_shop_items(**kwargs):
    ids = get_shop_item_ids()
    shop = GetShopItemsResponse()
    for x in ids:
        shop.id.append(x)
    return shop.SerializeToString()




