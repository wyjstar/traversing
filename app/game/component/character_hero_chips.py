# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:44.
"""
from app.game.component.Component import Component
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_info


class CharacterHeroChipsComponent(Component):
    """武将碎片组件"""
    def __init__(self, owner):
        super(CharacterHeroChipsComponent, self).__init__(owner)
        self._chips = {}

    def init_data(self, character_info):
        hero_chips_data = character_info.get('hero_chips', {})
        for no, num in hero_chips_data.items():
            hero_chip = HeroChip(no, num)
            self._chips[no] = hero_chip

    def save_data(self):
        props = {}
        for no, chip in self._chips.items():
            if chip.num <= 0:
                del self._chips[no]
                continue
            props[no] = chip.num

        items_data = tb_character_info.getObj(self.owner.base_info.id)
        items_data.hset('hero_chips', props)

    def new_data(self):
        return {'hero_chips': {}}

    @property
    def chips_count(self):
        return len(self._chips)

    def get_chip(self, chip_no):
        return self._chips.get(chip_no)

    def get_all(self):
        return self._chips.values()

    def is_afford(self, chip_no, chip_num):
        if chip_no not in self._chips:
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

    def get_num(self, hero_chip_no):
        if hero_chip_no in self._chips:  # 已经存在的item_no
            return self._chips[hero_chip_no].num
        else:
            return 0
