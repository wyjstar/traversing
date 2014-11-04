# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午6:02.
"""

from common_item import CommonGroupItem


def parse(data):

    item_group = []
    for typeid, lst in data.items():
        min_num = lst[0]
        max_num = lst[1]
        obj_id = lst[2]
        item_group.append(CommonGroupItem(obj_id, max_num, min_num, typeid))
    return item_group
