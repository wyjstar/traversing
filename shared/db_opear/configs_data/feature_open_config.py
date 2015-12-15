# -*- coding:utf-8 -*-
"""
"""
from shared.db_opear.configs_data.common_item import CommonGroupItem, CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class LotteryConfig(object):
    """LotteryConfig
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            convert_keystr2num(row.get("Probability"))

            self._items[row.get('id')] = CommonItem(row)

        return self._items
