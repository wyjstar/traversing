# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午1:42.
"""
from common_item import CommonItem


class StageShowConfig(object):

    def __init__(self):
        self._items={}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            obj = CommonItem(row)
            self._items[obj.trigger_1] = obj

        return self._items
