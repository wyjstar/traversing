# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:26.
"""
from app.game.component.baseInfo.equipment_base_info import EquipmentBaseInfoComponent
from app.game.component.equipment.equipment_attribute import EquipmentAttributeComponent
from app.game.component.pack.equipment_pack import EquipmentPackComponent
from app.game.redis_mode import tb_equipment_info


class Equipment(object):
    """装备
    """
    def __init__(self, equipment_id, equipment_name, equipment_no, \
                 strengthen_lv=1, awakening_lv=1):
        self._base_info = EquipmentBaseInfoComponent(self, equipment_id, equipment_name, equipment_no)
        self._attribute = EquipmentAttributeComponent(self, strengthen_lv, awakening_lv)

    def save_data(self, character_id):
        data = {'equipment_id': self._base_info.id, \
                'character_id': character_id, \
                'equipment_info': {'equipment_no': self._base_info.equipment_no, \
                                   'slv': self._attribute.strengthen_lv, \
                                   'alv': self._attribute.awakening_lv}}
        tb_equipment_info.new(data)

