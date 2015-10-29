# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午5:48.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data import data_helper
from shared.db_opear.configs_data.data_helper import parse


class IndianaConfig(object):
    """
    """

    def __init__(self):
        self._indiana = {}
        self._indexes = {}

    def parser(self, config_value):

        for row in config_value:
            # row["consume"] = parse(row.get("consume"))
            item = CommonItem(row)
            index = item.difficulty*100+item.quality*10+item.type

            self._indiana[item.id] = item
            self._indexes[index] = item.id

        return {'indiana': self._indiana, 'indexes': self._indexes}
