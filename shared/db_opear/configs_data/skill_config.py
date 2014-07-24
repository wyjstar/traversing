# -*- coding:utf-8 -*-
"""
created by server on 14-7-22上午10:36.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class SkillConfig(object):
    """技能配置
    """
    def __init__(self):
        self._skills = {}

    def parser(self, config_value):
        for row in config_value:
            item = CommonItem(row)
            self._skills[item.id] = item
        return self._skills