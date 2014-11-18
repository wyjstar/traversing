# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class SealConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
