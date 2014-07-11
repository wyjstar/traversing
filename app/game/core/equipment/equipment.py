# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:26.
"""
from app.game.component.baseInfo.equipment_base_info import EquipmentBaseInfoComponent
from app.game.component.equipment.equipment_attribute import EquipmentAttributeComponent
from app.game.component.record.equipment_enhance import EquipmentEnhanceComponent
from app.game.redis_mode import tb_equipment_info


class Equipment(object):
    """装备
    """
    def __init__(self, equipment_id, equipment_name, equipment_no, \
                 strengthen_lv=1, awakening_lv=1, enhance_record={}):
        self._base_info = EquipmentBaseInfoComponent(self, equipment_id, equipment_name, equipment_no)
        self._attribute = EquipmentAttributeComponent(self, strengthen_lv, awakening_lv)
        self._record = EquipmentEnhanceComponent(self, enhance_record)

    def save_data(self):
        equipment_info = self.equipment_info_dict()
        mmode = tb_equipment_info.getObj(self._base_info.id)
        mmode.update('equipment_info', equipment_info)

    def equipment_info_dict(self):
        equipment_info = {'equipment_no': self._base_info.equipment_no,
                'slv': self._attribute.strengthen_lv,
                'alv': self._attribute.awakening_lv,
                'enhance_info': self._record}
        return equipment_info

    @property
    def base_info(self):
        return self._base_info

    @property
    def attribute(self):
        return self._attribute

    def enhance(self):
        """强化
        """
        before_lv = self._attribute.strengthen_lv
        enhance_lv = 1
        # TODO 暴击强化修改enhance_lv
        self._attribute.modify_single_attr('strengthen_lv', enhance_lv, add=True)
        after_lv = self._attribute.strengthen_lv

        return before_lv, after_lv







