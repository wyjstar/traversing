# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem


class HeroConfig(object):
    """武将配置类"""
    def __init__(self):
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        heros = {}
        for row in config_value:
            self.heros[row.get('id')] = CommonItem(row)
        return self.heros

