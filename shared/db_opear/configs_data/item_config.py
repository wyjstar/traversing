# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:47.
"""


class Item(dict):
    def __getattr__(self, name):
        return self.get(name, None)


class ItemsConfig(object):
    """道具配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = Item(row)
            self._items[item.id] = item
        return self._items


