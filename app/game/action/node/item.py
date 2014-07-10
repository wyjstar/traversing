# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午4:16.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import item_pb2


@remote_service_handle
def get_items_301(dynamic_id, pro_data):
    """取得全部道具
    """
    print '301', dynamic_id, pro_data
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    print player
    game_items = player.item_package.items
    # game_items = {1000:1, 1001:2}
    items = item_pb2.ItemsResponse()
    item = items.item
    for item_no, item_num in game_items.items():
        _item = item.add()
        _item.item_no = item_no
        _item.item_num = item_num
    print 'items:', items.item
    return items.SerializePartialToString()


