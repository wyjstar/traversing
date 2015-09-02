# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" 字典相关扩展方法
"""


def dicttolist(dt):
    """
    字典转位列表

    Example:
        dicttolist({1: 'A', 2: 'B'})
        >> [1, 'A', 2, 'B']
    """
    ls = []
    for k, v in dt.items():
        ls.append(k)
        if type(v) in [list, tuple]:
            ls.extend(v)
        else:
            ls.append(v)
    return ls


def dictintvals(d):
    """
    把字典的value转为int型

    Example:
        dictintval({'A': '1', 'B': '2'})
        >> {'A': 1, 'B': 2}
    """
    return dict((k, int(v)) for k, v in d.items())


def dicttvalsplus(d1, d2):
    """
    d1, d2 为单层val为数值类型的字典
    把字典的相同key的value相加
    d1 will be changed

    Example:
        dictintval({'A': 1, 'B': 2}, {'B': 3, 'C': 4})
        >> {'A': 1, 'B': 5, 'C':4}
    """
    middle_dict = {}
    for key in d2.keys():
        middle_dict[key] = d1.get(key, 0) + d2.get(key, 0)
    d1.update(middle_dict)

    return d1
