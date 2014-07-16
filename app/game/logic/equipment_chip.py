# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:58.
"""

from app.proto_file.equipment_chip_pb2 import GetEquipmentChipsResponse
from app.game.logic.common.check import have_player


@have_player
def get_equipment_chips(dynamic_id, **kwargs):
    player = kwargs.get('player')
    response = GetEquipmentChipsResponse()
    for equipment_chip in player.equipment_chip_component.get_all():
        equipment_chip_pb = response.equipment_chips.add()
        equipment_chip.update_pb(equipment_chip_pb)
    return response.SerializePartialToString()