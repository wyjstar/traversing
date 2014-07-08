# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:07.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class EquipmentConfig(object):
    """装备配置类
    """

    def __init__(self):

        self._equipments = {}

    def parser(self, config_value):
        """解析
        """
        for row in config_value:
            self._equipments[row.get('id')] = CommonItem(row)
        return self._equipments