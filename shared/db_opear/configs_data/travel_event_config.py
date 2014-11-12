# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class TravelEventConfig(object):
    """
    """

    def __init__(self):
        self._events = {}
        self._weight = 0

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._weight += item.weight
            self._events[item.id] = item

        return {'events': self._events, 'weight': self._weight}

