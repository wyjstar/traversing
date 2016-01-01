# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data import data_helper
from shared.db_opear.configs_data.data_helper import parse


class StoneConfig(object):
    """
    """

    def __init__(self):
        self._stones = {}
        self._weight = []

    def parser(self, config_value):

        weights = 0
        for row in config_value:
            data_helper.convert_keystr2num(row.get('mainAttr'))
            data_helper.convert_keystr2num(row.get('minorAttr'))
            row["consume"] = parse(row.get("consume"))
            item = CommonItem(row)
            if item.weight:
                self._weight.append([item.id, weights+item.weight])
            self._stones[item.id] = item
            weights += item.weight

        return {'stones': self._stones, 'weight': self._weight}
