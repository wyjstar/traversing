# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午9:18.
"""
from app.game.component.Component import Component
from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.redis_mode import tb_character_equipment_chip


class CharacterEquipmentChipComponent(Component):
    """角色装备碎片
    """
    def __init__(self, owner):
        super(CharacterEquipmentChipComponent, self).__init__(owner)
        self._chips = {}

    def init_data(self):
        equipment_chip_data = tb_character_equipment_chip.getObjData(self.owner.base_info.id)
        if equipment_chip_data:
            chips = equipment_chip_data.get('chips')
            for chip_no, chip_num in chips.items():
                equipment_chip = EquipmentChip(chip_no, chip_num)
                self._chips[chip_no] = equipment_chip
        else:
            data = {'id': self.owner.base_info.id, 'chips': {}}
            tb_character_equipment_chip.new(data)

    def get_chip(self, chip_no):
        return self._chips.get(chip_no)

    def add_chip(self, equipment_chip):
        """添加碎片
        """
        if equipment_chip.chip_no in self._chips:  # 已经存在的item_no
            item_obj = self._chips[equipment_chip.chip_no]
            item_obj.modify_num(equipment_chip.chip_num, add=True)
        else:
            self._chips[equipment_chip.chip_no] = equipment_chip

    def save_data(self):
        props = {}
        for no, chip in self._chips.items():
            props[no] = chip.chip_num
        items_data = tb_character_equipment_chip.getObj(self.owner.base_info.id)
        items_data.update('chips', props)









