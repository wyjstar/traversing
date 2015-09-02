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
        self._weight = []

    def parser(self, config_value):
        def convert_keystr2num(d):
            for k in d.keys():
                nk = None
                v = d[k]
                try:
                    nk = eval(k)
                except:
                    pass
                if nk is not None:
                    del d[k]
                    d[nk] = v
                if isinstance(v, dict):
                    convert_keystr2num(v)

        for item in config_value:
            for k, v in item.items():
                if isinstance(v, dict):
                    convert_keystr2num(v)

        weights = 0
        for row in config_value:
            item = CommonItem(row)
            self._weight.append([item.id, weights+item.weight])
            self._events[item.id] = item
            weights += item.weight

        return {'events': self._events, 'weight': self._weight}
