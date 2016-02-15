# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" random相关扩展方法
"""

import random


def randbyodds(odds_dict, num_top=1):
    """
    从odds_dict随机出一个元素，num_top为随机数最大值

    Example:
        random_pick({"A": 0.1, "B": 0.3, "C": 0.7}, 1)
        >> C
    """
    pick_result = None
    x = random.uniform(0, num_top)
    odds_cur = 0.0
    for item, item_odds in odds_dict.items():
        if item_odds == 0:
            continue
        odds_cur += item_odds
        if x <= odds_cur:
            pick_result = item
            break
    return pick_result


def randbyweight(seq, weight):
    """
    weight为seq对应元素的随机权值

    Example:
        random_choose(["A", "B", "C"], [1, 2, 3])
        >> A
    """
    table = [z for x, y in zip(seq, weight) for z in [x] * y]
    if len(table) > 0:
        return random.choice(table)

def randomint(sn, en):
    """
    两个数之间随机一个数
    """
    return random.randint(sn, en)