# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午2:15.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class EquipmentStrengthenConfig(object):

    def __init__(self):

        self._equipment_strengthen = {}

    def parser(self, config_value):
        for row in config_value:
            self._equipment_strengthen[row.get('level')] = CommonItem(row)
        return self._equipment_strengthen
