# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:07.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data import data_helper


class EquipmentConfig(object):
    """装备配置类
    """

    def __init__(self):

        self._equipments = {}

    def parser(self, config_value):
        """解析
        """
        for row in config_value:
            if row.get('gain'):
                row['gain'] = data_helper.parse(row.get("gain"))

            if row['quality'] == 2:
                row['color'] = 1
            elif row['quality'] == 3 or row['quality'] == 4:
                row['color'] = 2
            elif row['quality'] == 5 or row['quality'] == 6:
                row['color'] = 3

            self._equipments[row.get('id')] = CommonItem(row)
        return self._equipments
