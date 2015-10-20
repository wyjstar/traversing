# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class AwakeConfig(object):
    """武将觉醒配置类"""
    def __init__(self):
        self.items = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            convert_keystr2num(row.get('triggerProbability'))
            row["singleConsumption"] = parse(row.get("singleConsumption"))
            row["silver"] = parse(row.get("silver"))
            self.items[row.get('level')] = CommonItem(row)
        return self.items
