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
            conditions = set()
            for i in range(1, 8):
                condition = row.get(u'condition%s' % i, None)
                if condition:
                    conditions.add(condition)
            row['conditions'] = conditions

            skill_ids = {}
            for i in range(1, 8):
                sid = row.get(r'triggle%s' % i, None)
                if sid:
                    skill_ids[i] = sid
            row['skill_ids'] = skill_ids

            expends = {}
            for i in range(1, 8):
                expend = row.get(r'expend%s' % i, None)
                if expend:
                    expends[i] = expend
            row['expends'] = expends

            self._warriors[row.get('id')] = CommonItem(row)

        return self._warriors
