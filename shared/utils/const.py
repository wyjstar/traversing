# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""

class ConstError(Exception):pass


class _const(object):
    """定义常量
    """
    def __init__(self, k, v):
        if k in self.__dict__:
            raise ConstError
        else:
            self.__dict__[k] = v


const = _const()