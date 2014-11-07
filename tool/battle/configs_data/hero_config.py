# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from data_helper import parse

class HeroConfig(object):
    """武将配置类"""
    def __init__(self):
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        heros = {}
        for row in config_value:
            row["sacrificeGain"] = parse(row.get("sacrificeGain"))
            row["sellGain"] = parse(row.get("sellGain"))
            self.heros[row.get('id')] = CommonItem(row)
        return self.heros

