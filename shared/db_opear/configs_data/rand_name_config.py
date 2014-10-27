# -*- coding:utf-8 -*-
"""
created by sphinx on 15/10/27.
"""

from shared.db_opear.configs_data.common_item import CommonItem


class RandNameConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        self._items['pre1'] = []
        self._items['pre2'] = []
        self._items['str'] = []
        for row in config_value:
            item = CommonItem(row)
            if item.get('prefix_1'):
                self._items['pre1'].append(item.get('prefix_1'))
            if item.get('prefix_2'):
                self._items['pre2'].append(item.get('prefix_2'))
            if item.get('office'):
                self._items['str'].append(item.get('office'))

        return self._items