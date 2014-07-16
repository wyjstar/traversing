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
from app.game.logic.soul_shop import soul_shop, get_shop_items


@remote_service_handle
def soul_shop_506(dynamic_id, pro_data):
    """武魂商店"""
    return soul_shop(dynamic_id, pro_data)


@remote_service_handle
def get_shop_items_507(dynamic_id, pro_data=None):
    """获取商品列表"""
    return get_shop_items()



