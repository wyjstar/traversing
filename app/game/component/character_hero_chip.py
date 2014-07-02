# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:44.
"""
from app.game.component.Component import Component
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_hero_chip, tb_character_info


class CharacterHeroChipComponent(Component):
    """武将碎片组件"""
    def __init__(self, owner):
        super(CharacterHeroChipComponent, self).__init__(owner)
        self._chip_list = {}

    def init_hero_chip_list(self, pid):
        character = tb_character_info.getObjData(pid)
        hero_chip_list_ids = character.get('data').get('hero_chip_list').split(',')
        hero_chip_list = tb_character_hero_chip.getObjList(hero_chip_list_ids)

        for chip_data in hero_chip_list:
            chip = HeroChip(chip_data)
            self.add_chip(chip)

    def add_chip(self, chip):
        self._chip_list[chip.chip_no] = chip

    def consume_chip(self, chips):
        """消耗碎片"""
        for chip_no, num in chips:
            chip = self._chip_list.get(chip_no)
            chip.consume(num)


