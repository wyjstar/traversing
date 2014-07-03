# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:27.
"""
from common_item import CommonItem


class HeroExpConfig(object):
    """武将配置类"""

    def __init__(self):
        self.hero_exps = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            self.hero_exps[row.get('level')] = CommonItem(row)
        return self.hero_exps
