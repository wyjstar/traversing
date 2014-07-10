# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午1:42.
"""
from common_item import CommonItem


class HeroChipConfig(object):

    def __init__(self):
        self.hero_chips = {}
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        hero_chips = {}
        for row in config_value:
            self.hero_chips[row.get('id')] = CommonItem(row)

        for row in config_value:
            self.heros[row.get('hero_id')] = CommonItem(row)

        hero_chips['hero_no'] = self.heros
        hero_chips['hero_chip_no'] = self.hero_chips
        return hero_chips