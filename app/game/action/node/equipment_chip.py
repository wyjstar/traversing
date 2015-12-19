# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:58.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.equipment_chip_pb2 import GetEquipmentChipsResponse
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def get_equipment_chips_407(pro_data, player):
    """取得武将碎片列表
    """
    response = GetEquipmentChipsResponse()
    for equipment_chip in player.equipment_chip_component.get_all():
        if equipment_chip.chip_num == 0:
            continue
        if not game_configs.chip_config.get('chips').get(equipment_chip.chip_no):
            del player.equipment_chip_component._chips[equipment_chip.chip_no]
            logger.error('chip config not found:%', equipment_chip.chip_no)
            continue

        equipment_chip_pb = response.equipment_chips.add()
        equipment_chip.update_pb(equipment_chip_pb)
    return response.SerializePartialToString()
