# -*- coding:utf-8 -*-
"""
created by server on 14-7-16上午11:47.
"""
from common_item import CommonItem
from data_helper import parse


class SoulShopConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["consume"] = parse(row.get("consume"))
            row["gain"] = parse(row.get("gain"))
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
