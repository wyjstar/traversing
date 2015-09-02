# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午2:46.
"""
import random
import copy
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.pack.drop_item import DropItem


class SmallBag(object):
    """掉落小包
    """
    def __init__(self):
        self._small_bag_id = 0  # 掉落小包ID
        self._drops = {}  # {'掉落ID':'掉落对象'}

    @property
    def small_bag_id(self):
        return self._small_bag_id

    @property
    def drops(self):
        return self._drops

    @small_bag_id.setter
    def small_bag_id(self, small_bag_id):
        self._small_bag_id = small_bag_id

    def get_drop_item(self, drop_id):
        return self._drops.get(drop_id)

    def add_drop_item(self, drop_item):
        """添加掉落信息
        """
        self._drops[drop_item.drop_id] = drop_item


class SmallBagsConfig(object):
    """掉落小包
    """
    def __init__(self):
        self._small_bags = {}  # {'掉落小包ID':'掉落小包对象'}

    def parser(self, config_value):
        for row in config_value:

            item = CommonItem(row)

            # 掉落道具对象
            drop_item = DropItem()
            drop_item.drop_id = item.subId
            drop_item.item_no = item.detailID
            drop_item.item_type = item.type
            drop_item.item_num = item.count
            drop_item.item_weight = item.weight

            # 组织掉落小包数据
            if item.dropId in self._small_bags:
                small_bag = self._small_bags.get(item.dropId)
            else:
                small_bag = SmallBag()
                small_bag.small_bag_id = item.dropId
                self._small_bags[item.dropId] = small_bag
            small_bag.add_drop_item(drop_item)

        return self._small_bags



