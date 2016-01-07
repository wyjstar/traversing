# -*- coding:utf-8 -*-
"""
created by server on 14-8-25
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
import time


class ActivityTypeConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        return {}

        for row in config_value:
            row["timeStart"] = time.mktime(time.strptime(row.get("timeStart"),
                                           '%Y-%m-%d %H:%M:%S'))
            row["timeEnd"] = time.mktime(time.strptime(row.get("timeEnd"),
                                         '%Y-%m-%d %H:%M:%S'))
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
