# -*- coding:utf-8 -*-
from shared.utils.ranking import Ranking


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
