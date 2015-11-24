# -*- coding:utf-8 -*-
"""
created by server on 14-7-16上午10:25.
"""
import random
import copy


def random_pick_with_weight(items):
    """
    根据权重获取随机item
    :param items: {1:50, 2: 50, ...}
    1:id
    50:权重
    :return id list:
    """
    pick_result = None
    random_max = sum(items.values())
    x = random.randint(0, random_max)
    odds_cur = 0
    for item_id, weight in items.items():
        odds_cur += weight
        if x <= odds_cur:
            pick_result = item_id
            break
    return pick_result

def random_pick_with_percent(items):
    """ 根据百分比获取随机item
    """
    pick_result = None
    random_max = sum(items.values())
    x = random.randint(0, 100)
    odds_cur = 0
    for item_id, percent in items.items():
        weight = percent*100
        odds_cur += weight
        if x <= odds_cur:
            pick_result = item_id
            break

    return pick_result



def random_multi_pick(items, times):
    """重复掉落多次"""
    drop_items = []
    for i in range(times):
        picked_item_id = random_pick_with_weight(items)

        if not picked_item_id:
            continue

        drop_items.append(picked_item_id)
    return drop_items


def random_multi_pick_without_repeat(items, times):
    """重复掉落多次，要去重
    """
    drop_items = []
    items_copy = copy.deepcopy(items)
    for i in range(times):
        picked_item_id = random_pick_with_weight(items_copy)

        if not picked_item_id:
            continue

        drop_items.append(picked_item_id)
        del items_copy[picked_item_id]

    return drop_items

def get_random_items_from_list(num, items=[]):
    """
    items is a list
    """
    res = []
    if len(items) < num:
        return []
    for no in random.sample(range(len(items)), num):
        res.append(items[no])
    return res
