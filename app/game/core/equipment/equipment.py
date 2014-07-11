# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:26.
"""
from app.game.component.baseInfo.equipment_base_info import EquipmentBaseInfoComponent
from app.game.component.equipment.equipment_attribute import EquipmentAttributeComponent
from app.game.component.record.equipment_enhance import EquipmentEnhanceComponent
from app.game.redis_mode import tb_equipment_info
from shared.db_opear.configs_data import game_configs


class Equipment(object):
    """装备
    """

    def __init__(self, equipment_id, equipment_name, equipment_no, \
                 strengthen_lv=1, awakening_lv=1, enhance_record={}, nobbing_effect={}):
        self._base_info = EquipmentBaseInfoComponent(self, equipment_id, equipment_name, equipment_no)
        self._attribute = EquipmentAttributeComponent(self, strengthen_lv, awakening_lv, nobbing_effect)
        self._record = EquipmentEnhanceComponent(self, enhance_record)

    def add_data(self, character_id):
        print 'sdjf;asdjfaksldjfklasdjfalk;sdjf'
        data = {'id': self._base_info.id, \
                'character_id': character_id, \
                'equipment_info': {'equipment_no': self._base_info.equipment_no, \
                                   'slv': self._attribute.strengthen_lv, \
                                   'alv': self._attribute.awakening_lv}, \
                'enhance_info': self._record.enhance_record, \
                'nobbing_effect': self._attribute.nobbing_effect}

        print '#1 ------:', data

        tb_equipment_info.new(data)

    def save_data(self):
        data = {
            'equipment_info': {'equipment_no': self._base_info.equipment_no, \
                               'slv': self._attribute.strengthen_lv, \
                               'alv': self._attribute.awakening_lv}, \
            'enhance_info': self._record.enhance_record, \
            'nobbing_effect': self._attribute.nobbing_effect
        }

        items_data = tb_equipment_info.getObj(self._base_info.id)
        items_data.update_multi(data)

    def delete(self):
        items_data = tb_equipment_info.getObj(self._base_info.id)
        items_data.delete()

        
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

    def nobbing(self):
        """锤炼
        """
        pass

    @property
    def melting_item(self):
        """熔炼获得的配置物品
        """
        equipment_no = self._base_info.equipment_no
        equ_config_obj = game_configs.equipment_config.get(equipment_no, None)
        # 无配置数据
        if not equ_config_obj:
            return None
        return equ_config_obj.gain










