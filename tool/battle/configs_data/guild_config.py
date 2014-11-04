# -*- coding:utf-8 -*-
"""
created by server on 14-8-20上午11:09.
"""


from common_item import CommonItem
from data_helper import parse


class GuildConfig(object):
    """武将配置类"""
    def __init__(self):
        self._guild = {}

    def parser(self, config_value):
        """解析config到GuildConfig"""
        for row in config_value:
            self._guild[row.get('level')] = CommonItem(row)
        return self._guild
