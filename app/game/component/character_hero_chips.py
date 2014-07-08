# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:44.
"""
from app.game.component.Component import Component
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_hero_chip, tb_character_info
from gtwisted.utils import log


class CharacterHeroChipsComponent(Component):
    """武将碎片组件"""
    def __init__(self, owner):
        super(CharacterHeroChipsComponent, self).__init__(owner)
        self._chips = {}

    def init_hero_chips(self, pid):
        hero_chips = tb_character_hero_chip.getObjData(self.owner.base_info.id)
        if hero_chips:
            hero_chips_data = hero_chips.get('hero_chips', {})
            for no, num in hero_chips_data:
                hero_chip = HeroChip(no, num)
                self._chips[no] = hero_chip
        else:
            tb_character_hero_chip.new({'id': self.owner.base_info.id, 'hero_chips': {}})

    def get_chip(self, chip_no):
        return self._chips.get(chip_no)
    
    def is_afford(self, chip_no, chip_num):
        if not chip_no in self._chips:
            return False
        if self._chips[chip_no].num < chip_num:
            return False
        return True

    def add_chip(self, hero_chip):
        """添加道具
        """
        if hero_chip.chip_no in self._chips:  # 已经存在的item_no
            self._chips[hero_chip.chip_no].num += hero_chip.num
        else:
            self._chips[hero_chip.chip_no] = hero_chip
        self.save_data()

    def save_data(self):
        props = {}
        for no, chip in self._chips.items():
            props[no] = chip.num

        items_data = tb_character_hero_chip.getObj(self.owner.base_info.id)
        items_data.update('hero_chips', props)


