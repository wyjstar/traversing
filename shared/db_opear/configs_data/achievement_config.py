# -*- coding:utf-8 -*-
"""
author:dotahero
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import convert_keystr2num
from shared.db_opear.configs_data.data_helper import parse


class AchievementConfig(object):
    def __init__(self):
        self._items = {}
        self._sort = {1: [], 2: [], 3: []}  # 1 成就 2 活跃度 3 分享
        self._unlock = {}  # 此id ：被开启ID
        self._conditions = {}  # 条件id：［有此条件的taskID］
        self._first_task = []  # 系列任务第一个

    def parser(self, config_value):
        for row in config_value:
            row["reward"] = parse(row.get("reward"))
            convert_keystr2num(row.get("condition"))
            item = CommonItem(row)

            self._items[item.id] = item
            if item.unlock:
                self._unlock[item.unlock] = item.id
            else:
                self._first_task.append(item.id)

            if item.sort == 2 or item.sort == 3:
                self._sort[2].append(item.id)
            elif item.sort == 1:
                self._sort[1].append(item.id)
            elif item.sort == 4:
                self._sort[3].append(item.id)

            for _, condition in item.condition.items():
                if self._conditions.get(condition[0]):
                    if item.id in self._conditions[condition[0]]:
                        continue
                    self._conditions[condition[0]].append(item.id)
                else:
                    self._conditions[condition[0]] = [item.id]

        return {'tasks': self._items,
                'sort': self._sort,
                'unlock': self._unlock,
                'conditions': self._conditions,
                'first_task': self._first_task}
