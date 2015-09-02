# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:58.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.equipment_chip_pb2 import GetEquipmentChipsResponse


@remoteserviceHandle('gate')
def get_equipment_chips_407(pro_data, player):
    """取得武将碎片列表
    """
    response = GetEquipmentChipsResponse()
    for equipment_chip in player.equipment_chip_component.get_all():
        equipment_chip_pb = response.equipment_chips.add()
        equipment_chip.update_pb(equipment_chip_pb)
    return response.SerializePartialToString()
