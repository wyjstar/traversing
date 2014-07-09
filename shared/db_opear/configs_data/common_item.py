# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:29.
"""
import random


class CommonItem(dict):
    """通用类"""
    def __getattr__(self, item):
        return self.get(item)


class CommonGroupItem():
    def __init__(self, obj_id, max_num, min_num):

        self._max_num = max_num
        self._min_num = min_num
        self._obj_id = obj_id

    @property
    def obj_id(self):
        return self._obj_id

    @property
    def num(self):
        if self._max_num == self._min_num:
            return self._max_num
        return random.randint(self._min_num, self._max_num)