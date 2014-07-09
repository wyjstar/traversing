# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午9:08.
"""
from shared.db_opear.configs_data.common_item import CommonItem


class SetEquipmentConfig(object):
    """装备套装
    """
    def __init__(self):
        self._set_equipment = {}

    def parser(self, config_value):
        for row in config_value:
            self._set_equipment[row.get('id')] = CommonItem(row)
        return self._set_equipment
