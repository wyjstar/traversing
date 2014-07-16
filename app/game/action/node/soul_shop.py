# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午8:33.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.soul_shop_pb2 import SoulShopRequest, GetShopItemsResponse
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import soul_shop_config
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.item_group_helper import is_afford, consume, gain, get_return
from app.proto_file.player_response_pb2 import GameResourcesResponse
from app.game.core.soul_shop import get_shop_item_ids

@remote_service_handle
def soul_shop_506(dynamic_id, pro_data):
    """武魂商店"""
    request = SoulShopRequest()
    request.ParseFromString(pro_data)
    game_resources_response = GameResourcesResponse()
    response = CommonResponse()
    game_resources_response.res = response

    shop_id = request.id
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    shop_item = soul_shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        response.result = False
        response.message = '消费不足！'
    consume(player, shop_item.consume)  # 消耗
    return_data = gain(player, shop_item.gain)  # 获取
    extra_return_data = gain(player, shop_item.extra_gain)  # 额外获取

    get_return(player, return_data, game_resources_response)
    get_return(player, extra_return_data, game_resources_response)

    response.result = True
    return game_resources_response.SerializeToString()


@remote_service_handle
def get_shop_items_507(dynamic_id, pro_data=None):
    """获取商品列表"""

    ids = get_shop_item_ids()
    shop = GetShopItemsResponse()
    for x in ids:
        shop.id.append(x)
    return shop.SerializeToString()



