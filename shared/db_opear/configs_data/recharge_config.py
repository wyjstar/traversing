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
            if item.get('platform') not in self._items:
                self._items[item.get('platform')] = {}
            self._items[item.get('platform')].update({item.goodsid: item})
            self._items[item.id] = item

        return self._items
