# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" math相关扩展方法
"""


def absmax(vals):
    """
    取集合中绝对值最大的值

    Example:
        absmax([-1, 2, -5])
        >> -5
    """
    max_val = None
    for v in vals:
        if max_val is None:
            max_val = v
            continue
        if abs(v) > max_val:
            max_val = v
    return max_val
