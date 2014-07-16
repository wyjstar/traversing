# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:25.
"""
from app.game.logic.common.check import have_player
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.shop_pb2 import ShopRequest
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import shop_config
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.item_group_helper import is_afford, consume, gain, get_return
from app.proto_file.player_response_pb2 import GameResourcesResponse


@have_player
def shop_oper(dynamic_id, pro_data, **kwargs):
    player = kwargs.get('player')
    """商城所有操作"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    game_resources_response = GameResourcesResponse()
    response = CommonResponse()
    game_resources_response.res = response

    shop_id = request.id
    shop_item = shop_config.get(shop_id)
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