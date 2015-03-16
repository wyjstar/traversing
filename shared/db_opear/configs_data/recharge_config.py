# -*- coding:utf-8 -*-
"""
created by server on 14-8-25
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class RechargeConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["setting"] = parse(row.get("setting"))
            row["fristGift"] = parse(row.get("fristGift"))
            item = CommonItem(row)
            self._items[item.goodsid] = item

        return self._items
