# -*- coding:utf-8 -*-
"""
created by sphinx on 15/12/1.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class FormulaConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            item['formula'] = compile(item.get('formula'), '', 'eval')
            item['precondition'] = compile(item.get('precondition'), '', 'eval')
            self._items[item.get('key')] = item

        return self._items
