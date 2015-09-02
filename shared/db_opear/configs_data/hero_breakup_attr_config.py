# -*- coding:utf-8 -*-
"""
created by server on 14-11-6下午2:46.
"""

from common_item import CommonItem

class HeroBreakupAttrConfig(object):
    """武将突破属性配置类"""
    def __init__(self):
        self.heros = {}

    def parser(self, config_value):
        """解析config到HeroBreakupAttrConfig"""
        for row in config_value:
            self.heros[row.get('id')] = CommonItem(row)
        return self.heros
