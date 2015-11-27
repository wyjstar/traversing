# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class GuildTaskConfig(object):
    """押运配置类"""
    def __init__(self):
        self.items = {}

    def parser(self, config_value):
        for row in config_value:
            convert_keystr2num(row.get('robbedPercentage'))
            convert_keystr2num(row.get('peoplePercentage'))
            row["reward1"] = parse(row.get("reward1"))
            row["reward2"] = parse(row.get("reward2"))
            row["reward3"] = parse(row.get("reward3"))
            self.items[row.get('id')] = CommonItem(row)
        return self.items
