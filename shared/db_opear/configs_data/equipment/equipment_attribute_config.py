# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:07.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data import data_helper


class EquipmentAttributeConfig(object):
    """装备配置类
    """

    def __init__(self):

        self._data = {}

    def parser(self, config_value):
        """解析
        """
        for row in config_value:
            data_helper.convert_keystr2num(row.get('mainAttr'))
            data_helper.convert_keystr2num(row.get('minorAttr'))
            self._data[row.get('id')] = CommonItem(row)
        return self._data
