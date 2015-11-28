# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午6:02.
"""

from shared.db_opear.configs_data.common_item import CommonGroupItem


def parse(data):

    item_group = []
    for typeid, lst in data.items():
        min_num = lst[0]
        max_num = lst[1]
        obj_id = lst[2]
        item_group.append(CommonGroupItem(obj_id, max_num, min_num, typeid))
    return item_group


def convert_keystr2num(d):
    for k in d.keys():
        nk = None
        v = d[k]
        try:
            nk = eval(k)
        except:
            pass
        if nk is not None:
            del d[k]
            d[nk] = v
        if isinstance(v, dict):
            convert_keystr2num(v)


def convert_common_resource2mail(common_rewards):
    mail_resource = []
    for group_item in common_rewards:
        mail_resource.append({group_item.item_type:[group_item.num, group_item.num, group_item.item_no]})
    return mail_resource



