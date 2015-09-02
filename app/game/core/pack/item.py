# -*- coding:utf-8 -*-
"""
created by server on 14-7-3上午11:46.
"""


class Item(object):
    """道具
    """
    def __init__(self, item_no, num):
        self._item_no = item_no  # 道具编号
        self._num = num  # 道具数量

    @property
    def item_no(self):
        return self._item_no

    @property
    def num(self):
        return self._num

    @num.setter
    def num(self, num):
        self._num = num

    def modify_num(self, num=0, add=True):
        if add:
            self._num += num
        else:
            self._num -= num
