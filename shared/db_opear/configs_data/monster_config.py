# -*- coding:utf-8 -*-
"""
created by server on 14-7-19下午7:39.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class MonsterConfig(object):
    def __init__(self):
        self._monsters = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._monsters[item.id] = item
        return self._monsters