# -*- coding:utf-8 -*-
"""
created by sphinx on 15/10/14.
"""

from shared.db_opear.configs_data.common_item import CommonItem


class NotesConfig(object):
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            # if isinstance(row.get("effectPos"), dict):
            #     convert_keystr2num(row.get("effectPos"))
            item = CommonItem(row)
            self._items[item.id] = item

        return self._items
