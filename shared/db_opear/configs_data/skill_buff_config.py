# -*- coding:utf-8 -*-
"""
created by server on 14-7-22上午10:36.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class SkillBuffConfig(object):
    """BUFF配置
    """
    def __init__(self):
        self._buffs = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._buffs[item.id] = item
        return self._buffs