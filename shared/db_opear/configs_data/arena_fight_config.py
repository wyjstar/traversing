# -*- coding:utf-8 -*-
"""
created by sphinx on 31/10/14.
"""

from shared.db_opear.configs_data.common_item import CommonItem


class ArenaFightConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            data = item.get('choose')
            if data:
                data = compile(data, '', 'eval')
                item['choose'] = data
            self._items[item.id] = item

        return self._items
