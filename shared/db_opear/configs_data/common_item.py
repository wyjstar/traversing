# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午8:29.
"""
import random


class CommonItem(dict):
    """通用类"""

    def __getattr__(self, item):
        try:
            return self.__getitem__(item)
        except KeyError:
            raise AttributeError(item)

    def __add__(self, other):
        """重载加法运算
        """
        for k, v in self.items():
            if k in other.keys():
                other[k] += v
            else:
                other[k] = v
        return other

    def __getstate__(self):
        return self.__dict__


class CommonGroupItem():
    def __init__(self, item_no, max_num, min_num, item_type):
        self._max_num = int(max_num)
        self._min_num = int(min_num)
        self._item_no = int(item_no)
        self._item_type = int(item_type)

    @property
    def item_no(self):
        return self._item_no

    @property
    def num(self):
        return random.randint(self._min_num, self._max_num)

    @property
    def item_type(self):
        return self._item_type

    def __repr__(self):
        """docstring for __repr__fname"""
        return "%s %s %s %s" % (self._max_num, self._min_num, self._item_no, self._item_type)


if __name__ == '__main__':
    a = {'a':1, 'b':2}
    b = {'c':3, 'b':2}

    test_a = CommonItem(b)
    import copy
    copy.deepcopy(test_a)

    test_b = CommonItem(b)

    test_c = test_a + test_b
    print id(test_a)
    print id(test_b)
    print test_c
    print test_c.c
    import cPickle
    cPickle.dumps(test_a)


