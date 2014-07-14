# -*- coding:utf-8 -*-
"""
created by server on 14-7-10上午11:32.
"""
import random
import copy
from shared.db_opear.configs_data.game_configs import big_bag_config, small_bag_config
from shared.db_opear.configs_data.common_item import CommonGroupItem


class BigBag(object):

    def __init__(self, big_bag_config_id):
        self.big_bag = big_bag_config.get(big_bag_config_id)

    def get_drop_items(self):
        drop_items = []
        for small_bag_id, small_bag_times, is_uniq in \
                zip(self.big_bag.small_packages, self.big_bag.small_package_times, self.big_bag.is_uniq_list):
            small_bag = SmallBag(small_bag_id)

            if is_uniq:
                lst = small_bag.random_multi_pick_without_repeat(small_bag_times)
                drop_items.extend(lst)
            else:
                lst = small_bag.random_multi_pick(small_bag_times)
                drop_items.extend(lst)

        drop_item_group = []
        for drop_item in drop_items:
            drop_item_type = drop_item.item_type
            drop_item_no = drop_item.item_no
            drop_item_num = drop_item.item_num
            drop_item_group.append(CommonGroupItem(drop_item_no, drop_item_num, drop_item_num, drop_item_type))
        return drop_item_group


class SmallBag(object):

    def __init__(self, small_bag_config_id):
        self.small_bag = small_bag_config.get(small_bag_config_id)

    def random_pick(self):
        """随机掉落
        """
        return self.__do_random()

    def random_multi_pick(self, times):
        """重复掉落多次
        """
        drop_items = []
        for i in range(times):
            picked_item = self.random_pick()

            if not picked_item:
                continue

            drop_items.append(picked_item)
        return drop_items

    def random_multi_pick_without_repeat(self, times):
        """重复掉落多次，要去重
        """
        drop_items = []

        small_bag_copy = copy.deepcopy(self.small_bag)
        for i in range(times):
            picked_item = small_bag_copy.random_pick()

            if not picked_item:
                continue

            drop_items.append(picked_item)
            small_bag_copy.del_drop_item(picked_item)

        return drop_items

    def __do_random(self):
        pick_result = None
        odds_dict = {}
        for items_id, items in self.small_bag.drops.items():
            odds_dict[items] = items.item_weight
        random_max = sum(odds_dict.values())
        x = random.randint(0, random_max)
        odds_cur = 0
        for items, weight in odds_dict.items():
            odds_cur += weight
            if x <= odds_cur:
                pick_result = items
                break
        return pick_result