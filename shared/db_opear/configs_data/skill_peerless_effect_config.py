# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem

class PeerlessEffectConfig(object):
    """无双辅助技能配置类"""
    def __init__(self):
        self.items = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            self.items[row.get('id')] = CommonItem(row)
        return self.items
