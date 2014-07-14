# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午5:25.
"""

from app.game.service.gatenoteservice import remote_service_handle

from app.game.core.PlayersManager import PlayersManager
from app.proto_file.line_up_pb2 import AddHeroRequest, ChangeHeroRequest, ChangeEquipmentsRequest, ChangeLineUpOrderRequest


@remote_service_handle
def add_hero(dynamic_id, pro_data):
    """添加武将"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = AddHeroRequest()
    request.ParseFromString(pro_data)
    player.line_up_component.add_hero(request.hero_no)
    player.line_up_component.save_data()


@remote_service_handle
def change_hero(dynamic_id, pro_data):
    """更换武将"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeHeroRequest()
    request.ParseFromString(pro_data)
    line_up_item = player.line_up_component.get_line_up_item(request.line_up_item_id)
    line_up_item.hero_no = request.hero_no
    player.line_up_component.save_data()


@remote_service_handle
def change_equipments(dynamic_id, pro_data):
    """更换装备"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeEquipmentsRequest()
    request.ParseFromString(pro_data)
    line_up_item = player.line_up_component.get_line_up_item(request.line_up_item_id)
    line_up_item.equipment_ids = request.equipment_ids
    player.line_up_component.save_data()


@remote_service_handle
def change_line_up_order(dynamic_id, pro_data):
    """布阵"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeLineUpOrderRequest()
    request.ParseFromString(pro_data)
    player.line_up_component.line_up_order = request.line_up_order
    player.line_up_component.save_data()





