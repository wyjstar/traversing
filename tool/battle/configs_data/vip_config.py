# -*- coding:utf-8 -*-
"""
created by server on 14-9-12上午9:43.
"""

from common_item import CommonGroupItem, CommonItem
from data_helper import parse


class VIPConfig(object):
    """vip
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            self._items[row.get('id')] = CommonItem(row)

        return self._items
