# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午7:39.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class MonsterGroupConfig(object):
    def __init__(self):
        self._monster_group = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._monster_group[item.id] = item
        return self._monster_group