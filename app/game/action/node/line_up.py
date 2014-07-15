# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午5:25.
"""

from app.game.service.gatenoteservice import remote_service_handle

from app.game.core.PlayersManager import PlayersManager
from app.proto_file.line_up_pb2 import AddHeroRequest, ChangeHeroRequest, \
    ChangeEquipmentsRequest, ChangeLineUpOrderRequest
from app.proto_file.common_pb2 import CommonResponse


@remote_service_handle
def add_hero_701(dynamic_id, pro_data):
    """添加武将"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = AddHeroRequest()
    request.ParseFromString(pro_data)
    response = CommonResponse()
    # 校验
    line_up_slot_count = len(player.line_up_component.get_all())
    if line_up_slot_count == 5 and player.level < 22:
        response.result = False
        response.message = "等级不够，第六个卡位未解锁！"
        return response

    player.line_up_component.add_hero(request.hero_no)
    player.line_up_component.save_data()


@remote_service_handle
def change_hero_702(dynamic_id, pro_data):
    """更换武将"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeHeroRequest()
    request.ParseFromString(pro_data)
    line_up_slot = player.line_up_component.get_line_up_slot(request.line_up_slot_id)
    line_up_slot.hero_no = request.hero_no
    player.line_up_component.save_data()


@remote_service_handle
def change_equipments_703(dynamic_id, pro_data):
    """更换装备"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeEquipmentsRequest()
    request.ParseFromString(pro_data)
    equipment_ids = [x for x in request.equipment_ids]

    common_response = CommonResponse()
    # 校验
    if len(equipment_ids) != 6:
        common_response.result = False
        common_response.message = "装备数量！=6"
        return common_response

    line_up_slot = player.line_up_component.get_line_up_slot(request.line_up_slot_id)
    line_up_slot.equipment_ids = equipment_ids
    player.line_up_component.save_data()


@remote_service_handle
def change_line_up_order_704(dynamic_id, pro_data):
    """布阵"""
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)

    request = ChangeLineUpOrderRequest()
    request.ParseFromString(pro_data)
    line_up_order = [x for x in request.line_up_order]

    player.line_up_component.line_up_order = line_up_order
    player.line_up_component.save_data()





