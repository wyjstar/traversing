# -*- coding:utf-8 -*-
"""
created by server on 14-9-12上午9:43.
"""

from shared.db_opear.configs_data.data_helper import convert_keystr2num
# from shared.db_opear.configs_data.common_item import CommonGroupItem
from shared.db_opear.configs_data.common_item import CommonItem
# from shared.db_opear.configs_data.data_helper import parse


class VIPConfig(object):
    """vip
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            convert_keystr2num(row.get("shopOpen"))
            convert_keystr2num(row.get("shopRefreshTime"))
            self._items[row.get('id')] = CommonItem(row)

        return self._items
