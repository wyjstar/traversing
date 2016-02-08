# -*- coding:utf-8 -*-
"""
"""
from shared.db_opear.configs_data.common_item import CommonItem


class FeaturesOpenConfig(object):
    """FeaturesOpenConfig
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            self._items[row.get('type')] = CommonItem(row)

        return self._items
