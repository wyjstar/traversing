# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:29.
"""
import random


class CommonItem(dict):
    """通用类"""
    def __getattr__(self, item):
        return self.get(item)

    def __add__(self, other):
        """重载加法运算
        """
        for k, v in self.items():
            if k in other.keys():
                other[k] += v
            else:
                other[k] = v
        return other


class CommonGroupItem():
    def __init__(self, item_no, max_num, min_num, item_type):

        self._max_num = max_num
        self._min_num = min_num
        self._item_no = item_no
        self._item_type = item_type

    @property
    def item_no(self):
        return self._item_no

    @property
    def num(self):
        if self._max_num == self._min_num:
            return self._max_num
        return random.randint(self._min_num, self._max_num)

    @property
    def item_type(self):
        return self._item_type

if __name__ == '__main__':
    a = {'a':1, 'b':2}
    b = {'c':3, 'b':2}

    test_a = CommonItem()
    test_b = CommonItem(b)

    test_c = test_a + test_b
    print id(test_a)
    print id(test_b)
    print id(test_c)
    print test_c.c
