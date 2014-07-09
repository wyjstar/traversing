# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonGroupItem


class ShopConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            item = ShopConfig.ShopItem(row)
            self._items[item.id] = item
        return self._items

    class ShopItem(object):
        def __init__(self, row):
            self.consume_item_group = {}
            self.get_item_group = {}
            self.extra_get_item_group = {}
            for typeid, lst in row.get("consume"):
                max_num = lst[0]
                min_num = lst[1]
                obj_id = lst[2]
                self.consume_item_group[typeid] = CommonGroupItem(obj_id, max_num, min_num)

            for typeid, lst in row.get("get"):
                max_num = lst[0]
                min_num = lst[1]
                obj_id = lst[2]
                self.get_item_group[typeid] = CommonGroupItem(obj_id, max_num, min_num)

            for typeid, lst in row.get("extra_get"):
                max_num = lst[0]
                min_num = lst[1]
                obj_id = lst[2]
                self.extra_get_item_group[typeid] = CommonGroupItem(obj_id, max_num, min_num)






