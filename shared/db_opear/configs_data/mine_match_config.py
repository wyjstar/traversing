# -*- coding:utf-8 -*-
'''
Created on 2014-11-25

@author: hack
'''
from shared.db_opear.configs_data.common_item import CommonItem
    
class MineMatchConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._items[item.id] = item
        return self._items