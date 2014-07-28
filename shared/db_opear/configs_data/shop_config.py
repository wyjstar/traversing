# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonGroupItem, CommonItem
from shared.db_opear.configs_data.data_helper import parse


class ShopConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["consume"] = parse(row.get("consume"))
            row["gain"] = parse(row.get("gain"))
            row["extraGain"] = parse(row.get("extraGain"))
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items









