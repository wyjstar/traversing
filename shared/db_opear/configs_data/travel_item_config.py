# -*- coding:utf-8 -*-
"""
created by server on 14-8-25
"""

from shared.db_opear.configs_data.common_item import CommonItem


class TravelItemConfig(object):
    def __init__(self):
        self._items = {}
        self._group = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._items[item.id] = item
            if self._group.get(item.group):
                self._group[item.group].append(item.id)
            else:
                self._group[item.group] = [item.id]

        return {'items': self._items, 'groups': self._group}
