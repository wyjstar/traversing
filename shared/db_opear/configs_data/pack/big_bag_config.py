# -*- coding:utf-8 -*-
"""
created by server on 14-7-4下午5:02.
"""
from shared.db_opear.configs_data.common_item import CommonItem

class BigBag(object):
    def __init__(self):
        self._big_bag_id = 0
        self._small_packages = []
        self._small_package_times = []
        self._is_uniq_list = []

    @property
    def big_bag_id(self):
        return self._big_bag_id

    @big_bag_id.setter
    def big_bag_id(self, big_bag_id):
        self._big_bag_id = big_bag_id

    @property
    def small_packages(self):
        return self._small_packages

    @small_packages.setter
    def small_packages(self, small_packages):
        self._small_packages = small_packages

    @property
    def small_package_times(self):
        return self._small_package_times

    @small_package_times.setter
    def small_package_times(self, small_package_times):
        self._small_package_times = small_package_times

    @property
    def is_uniq_list(self):
        return self._is_uniq_list

    @is_uniq_list.setter
    def is_uniq_list(self, is_uniq_list):
        self._is_uniq_list = is_uniq_list


class BigBagsConfig(object):

    def __init__(self):
        self._big_bags = {}

    def parser(self, config_value):
        for row in config_value:

            item = CommonItem(row)

            big_bag = BigBag()
            big_bag.big_bag_id = item.id
            big_bag.small_packages = item.smallPacketId
            big_bag.is_uniq_list = item.isUniq
            big_bag.small_package_times = item.smallPacketTimes
            self._big_bags[big_bag.big_bag_id] = big_bag

        return self._big_bags