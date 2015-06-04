# -*- coding:utf-8 -*-
from shared.utils.ranking import Ranking
import time


def remove_rank(rank_name, key):
    instance = Ranking.instance(rank_name)
    instance.remove(key)  # 删除rank数据


def add_rank_info(rank_name, key, value):
    instance = Ranking.instance(rank_name)
    instance.add(key, value)  # 添加rank数据


def get_rank_by_key(rank_name, key):
    instance = Ranking.instance(rank_name)
    return instance.get_rank_no(key)  # 添加rank数据


def get_rank(rank_name, first_no, last_no):
    instance = Ranking.instance(rank_name)
    return instance.get(first_no, last_no)  # 获取排行最高的列表(9999条)


def get_value(rank_name, key):
    instance = Ranking.instance(rank_name)
    return instance.get_value(key)  # 获取排行最高的列表(9999条)


def flag_doublu_day():
    """
    return 0 or 1
    """
    now = int(time.time())
    t = time.localtime(now)
    time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                        '%Y-%m-%d %H:%M:%S'))
    return int(time1/(24*60*60)) % 2
