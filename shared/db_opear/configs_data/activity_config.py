# -*- coding:utf-8 -*-
"""
created by server on 14-8-25
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
import time


class ActivityConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["reward"] = parse(row.get("reward"))
            row["timeStart"] = time.mktime(time.strptime(row.get("timeStart"),
                                           '%Y-%m-%d %H:%M:%S'))
            row["timeEnd"] = time.mktime(time.strptime(row.get("timeEnd"),
                                         '%Y-%m-%d %H:%M:%S'))
            item = CommonItem(row)
            if item.type == 5:
                if not self._items.get(item.type):
                    self._items[item.type] = {item.parameterA: item}
                self._items[item.type][item.parameterA] = item
            else:
                if not self._items.get(item.type):
                    self._items[item.type] = []
                self._items[item.type].append(item)
            self._items[item.id] = item

        return self._items
