# -*- coding:utf-8 -*-
"""
created by server on 14-10-27下午6:03.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class PlayerExpConfig(object):
    """玩家经验
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            self._items[row.get('level')] = CommonItem(row)

        return self._items