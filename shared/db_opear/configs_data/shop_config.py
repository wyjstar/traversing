# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num
from shared.db_opear.configs_data.data_helper import parse


class ShopConfig(object):
    """shop配置
    """

    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get("weightGroup"))
            convert_keystr2num(row.get("limitVIPeveryday"))
            convert_keystr2num(row.get("limitVIP"))
            convert_keystr2num(row.get("dutyFree"))
            convert_keystr2num(row.get("contribution"))
            convert_keystr2num(row.get("attr"))
            row["consume"] = parse(row.get("consume"))
            row["alternativeConsume"] = parse(row.get("alternativeConsume"))
            row["gain"] = parse(row.get("gain"))
            row["Integral"] = parse(row.get("Integral"))
            row["extraGain"] = parse(row.get("extraGain"))
            row["discountPrice"] = parse(row.get("discountPrice"))
            row["ExchangeValue"] = parse(row.get("ExchangeValue"))
            item = CommonItem(row)
            self._items[item.id] = item

            if item.type not in self._items:
                self._items[item.type] = []

            type_shop = self._items[item.type]
            type_shop.append(item)

        return self._items
