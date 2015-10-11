# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:47.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class CurrencyConfig(object):
    """货币资源配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row['buyPrice'])
            item = CommonItem(row)
            self._items[item.id] = item
        return self._items
