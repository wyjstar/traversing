# -*- coding:utf-8 -*-
"""
created by server on 14-8-25下午8:42.
"""
#from shared.db_opear.configs_data.common_item import CommonGroupItem, CommonItem
from shared.db_opear.configs_data.data_helper import parse


class SignInConfig(object):
    """每日签到
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):

        for row in config_value:
            mouth = row["month"]
            day = row["times"]
            if mouth not in self._items:
                self._items[mouth] = {}
            self._items[mouth][day] = {}
            self._items[mouth][day]["reward"] = parse(row.get("reward"))
            self._items[mouth][day]["vipDouble"] = row.get("vipDouble")
            self._items[mouth][day]["id"] = row.get("id")

        return self._items
