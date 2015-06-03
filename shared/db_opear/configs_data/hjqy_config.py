# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午5:22.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class HjqyConfig(object):

    def __init__(self):
        self._link = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            item["rewards"] = parse(item.get('rewards'))
            self._link[item.id] = item
        return self._link
