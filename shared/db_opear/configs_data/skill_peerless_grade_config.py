# -*- coding:utf-8 -*-
"""
created by server on 14-6-26下午3:39.
"""


from common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class PeerlessGradeConfig(object):
    """无双技能配置类"""
    def __init__(self):
        self.items = {}

    def parser(self, config_value):
        """解析config到HeroConfig"""
        for row in config_value:
            row["resource1"] = parse(row.get("resource1"))
            row["resource2"] = parse(row.get("resource2"))
            self.items[row.get('id')] = CommonItem(row)
        return self.items
