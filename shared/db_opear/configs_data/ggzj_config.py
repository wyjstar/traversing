# -*- coding:utf-8 -*-
"""
created by server on 15-10-9
"""
from shared.db_opear.configs_data.data_helper import convert_keystr2num
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class GgzjConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get("buff1"))
            convert_keystr2num(row.get("buff2"))
            convert_keystr2num(row.get("buff3"))
            row["reward1"] = parse(row.get("reward1"))
            row["reward2"] = parse(row.get("reward2"))
            row["database"] = parse(row.get("database"))
            row["index"] = row.get("section") * 3 + row.get('difficulty') - 3
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
