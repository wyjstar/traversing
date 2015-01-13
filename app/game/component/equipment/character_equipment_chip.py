# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午9:18.
"""
from app.game.component.Component import Component
from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.redis_mode import tb_character_info


class CharacterEquipmentChipComponent(Component):
    """角色装备碎片
    """
    def __init__(self, owner):
        super(CharacterEquipmentChipComponent, self).__init__(owner)
        self._chips = {}

    def init_data(self, character_info):
        chips = character_info.get('equipment_chips')
        for chip_no, chip_num in chips.items():
            equipment_chip = EquipmentChip(chip_no, chip_num)
            self._chips[chip_no] = equipment_chip

    def new_data(self):
        return {'equipment_chips': {}}

    def get_chip(self, chip_no):
        chip = self._chips.get(chip_no)
        return chip

    def get_all(self):
        return self._chips.values()

    def add_chip(self, equipment_chip):
        """添加碎片
        """
        if equipment_chip.chip_no in self._chips:  # 已经存在的item_no
            item_obj = self._chips[equipment_chip.chip_no]
            item_obj.modify_single_attr('chip_num',
                                        equipment_chip.chip_num,
                                        add=True)
        else:
            self._chips[equipment_chip.chip_no] = equipment_chip

    def save_data(self):
        props = {}
        for no, chip in self._chips.items():
            if chip.chip_num:  # 如果chip num == 0, 则不保存
                props[no] = chip.chip_num
        items_data = tb_character_info.getObj(self.owner.base_info.id)
        items_data.hset('equipment_chips', props)

    # def get_chip_num(self, chip_no):
    #     """根据碎片编号取得当前个数
    #     """
    #     chip_num = 0
    #     chip = self.get_chip(chip_no)
    #     if chip:
    #         chip_num = chip.chip_num
    #     return chip_num
