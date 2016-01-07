# -*- coding:utf-8 -*-
"""
created by server on 14-8-25
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num
import time
import re


class ActivityConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["reward"] = parse(row.get("reward"))
            if re.search(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}',
                         row["timeStart"]):
                row["timeStart"] = time.mktime(
                    time.strptime(row.get("timeStart"), '%Y-%m-%d %H:%M:%S'))
            else:
                row["timeStart"] = int(row["timeStart"])

            if re.search(r'\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}',
                         row["timeEnd"]):
                row["timeEnd"] = time.mktime(time.strptime(row.get("timeEnd"),
                                             '%Y-%m-%d %H:%M:%S'))
            else:
                row["timeEnd"] = int(row["timeEnd"])
            item = CommonItem(row)
            if item.type == 5:  # 等级推送特殊处理，等级和对应活动信息的映射
                if not self._items.get(item.type):
                    self._items[item.type] = {item.parameterA: item}
                self._items[item.type][item.parameterA] = item
            else:  # 类型与相对应的活动ID列表的映射
                if not self._items.get(item.type):
                    self._items[item.type] = []
                self._items[item.type].append(item)

            if item.premise:
                if not self._items.get('premise'):
                    self._items['premise'] = {}
                if not self._items.get('premise').get(item.premise):
                    self._items['premise'][item.premise] = []
                self._items['premise'][item.premise].append(item.id)

            self._items[item.id] = item

        return self._items
