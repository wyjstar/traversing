# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:47.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class ItemsConfig(object):
    """道具配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._items[item.id] = item
        return self._items


