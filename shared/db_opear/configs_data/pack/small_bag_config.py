# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午2:46.
"""
import random
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

    @small_bag_id.setter
    def small_bag_id(self, small_bag_id):
        self._small_bag_id = small_bag_id

    def add_drop_item(self, drop_item):
        """添加掉落信息
        """
        self._drops[drop_item.drop_id] = drop_item

    def del_drop_item(self, drop_item):

        if drop_item.drop_id in self._drops:
            try:
                del self._drops[drop_item.drop_id]
            finally:
                pass

    def random_pick(self):
        """随机掉落
        """
        return self.__do_random()

    def __do_random(self):
        pick_result = None
        odds_dict = {}
        for items_id, items in self._drops.items():
            odds_dict[items] = items.item_weight
        random_max = sum(odds_dict.values())
        x = random.randint(0, random_max)
        odds_cur = 0
        for items, item_odds in odds_dict.items():
            odds_cur += item_odds
            if x <= odds_cur:
                pick_result = items
                break
        return pick_result


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
            drop_item.item_count = item.count
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


