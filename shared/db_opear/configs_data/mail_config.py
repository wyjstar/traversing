# -*- coding:utf-8 -*-
"""
created by sphinx on 15/10/14.
"""

from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.data_helper import convert_keystr2num


class MailConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            # if isinstance(row.get("effectPos"), dict):
            #     convert_keystr2num(row.get("effectPos"))
            convert_keystr2num(row.get('rewards'))
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
