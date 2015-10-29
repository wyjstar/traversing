# -*- coding:utf-8 -*-
"""
created by sphinx on 31/10/14.
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class ArenaFightConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            data = row.get('choose')
            row["Reward"] = parse(row.get("Reward"))
            if data:
                data = compile(data, '', 'eval')
                row['choose'] = data
            item = CommonItem(row)
            self._items[item.id] = row

        return self._items
