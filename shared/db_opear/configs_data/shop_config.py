# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class ShopConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get("consume"))
            convert_keystr2num(row.get("gain"))
            convert_keystr2num(row.get("extraGain"))
            convert_keystr2num(row.get("weightGroup"))
            item = CommonItem(row)
            self._items[item.id] = item

            if item.type not in self._items:
                self._items[item.type] = []

            type_shop = self._items[item.type]
            type_shop.append(item)

        return self._items
