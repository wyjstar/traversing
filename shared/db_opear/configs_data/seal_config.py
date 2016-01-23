# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午3:28.
"""
from shared.db_opear.configs_data.common_item import CommonItem
from shared.db_opear.configs_data.data_helper import parse


class SealConfig(object):
    """shop配置
    """
    def __init__(self):
        self._items = {}

    def parser(self, config_value):
        for row in config_value:
            row["expend"] = parse(row.get("expend"))
            item = CommonItem(row)
            self._items[item.id] = item
            if item.pulse not in self._items:
                self._items[item.pulse] = []
            self._items[item.pulse].append(item)

        #start_id = min(self._items.keys())

        #def accumulate_next(cur_id):
            #cur_item = self._items.get(cur_id)
            #if not cur_item:
                #return
            #next_id = cur_item.get('next')
            #next_item = self._items.get(next_id)
            #if next_id and next_item:
                #for k, v in next_item.items():
                    #if isinstance(v, float):
                        #next_item[k] += cur_item[k]
            #accumulate_next(next_id)

        #accumulate_next(start_id)
        return self._items
