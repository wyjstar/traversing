# -*- coding:utf-8 -*-
"""
created by server on 14-12-15下午10:07.
"""
from shared.db_opear.configs_data import data_helper
from shared.db_opear.configs_data.data_helper import parse


class NewbeeGuideConfig(object):
    """装备配置类
    """

    def __init__(self):

        self._data = {}

    def parser(self, config_value):
        """解析
        """
        for row in config_value:
            data_helper.convert_keystr2num(row.get('rewards'))
            row["rewards"] = parse(row.get("rewards"))
            row["consume"] = parse(row.get("consume"))
            self._data[row.get('id')] = row
        return self._data
