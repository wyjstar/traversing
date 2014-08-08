# -*- coding:utf-8 -*-
"""
created by server on 14-7-10上午11:32.
"""
import random
import copy
from shared.db_opear.configs_data.game_configs import big_bag_config, small_bag_config
from shared.db_opear.configs_data.common_item import CommonGroupItem
from shared.utils.random_pick import *


class BigBag(object):

    def __init__(self, big_bag_config_id):
        self.big_bag = big_bag_config.get(big_bag_config_id)
        if not self.big_bag:
            print "big_bag is None", big_bag_config_id

    def get_drop_items(self):
        """获取大包内物品"""
        drop_items = []
        try:
            for small_bag_id, small_bag_times, is_uniq in \
                    zip(self.big_bag.small_packages, self.big_bag.small_package_times, self.big_bag.is_uniq_list):
                small_bag = SmallBag(small_bag_id)
                items = small_bag.get_drop_items()
                if is_uniq:
                    ids = random_multi_pick_without_repeat(items, small_bag_times)
                else:
                    ids = random_multi_pick(items, small_bag_times)
                for drop_id in ids:
                    drop_items.append(small_bag.get_drop_item(drop_id))
        except Exception as ex:
            print("config error!")
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

    def get_drop_items(self):
        data = {}
        for drop_id, drop_item in self.small_bag.drops.items():
            data[drop_id] = drop_item.item_weight

        return data

    def get_drop_item(self, drop_id):
        return self.small_bag.get_drop_item(drop_id)