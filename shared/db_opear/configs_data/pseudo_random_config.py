# -*- coding:utf-8 -*-
"""
伪随机
created by wzp.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num

class PseudoRandomConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get("gain"))
            item = CommonItem(row)
            item["gain"] = row.get("gain")
            self._items[item.id] = item

        return self._items
