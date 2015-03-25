# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午5:22.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class LuckyHeroConfig(object):

    def __init__(self):
        self._item = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._item[item.id] = item
        return self._item
