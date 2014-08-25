# -*- coding:utf-8 -*-
"""
created by server on 14-8-25下午6:07.
"""
from common_item import CommonItem


class WarriorsConfig(object):
    """无双配置
    """
    def __init__(self):
        self._warriors = {}

    def parser(self, config_value):
        for row in config_value:
            self._warriors[row.get('id')] = CommonItem(row)
        return self._warriors