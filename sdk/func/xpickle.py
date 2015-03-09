# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" pickle相关扩展方法
"""

import cPickle


def dumps(o):
    """
    压缩对象

    Example:
        dumps({1: 'A'})
        >> �}qKUAs.
    """
    return cPickle.dumps(o, cPickle.HIGHEST_PROTOCOL)


def loads(s):
    """
    解压数据

    Example:
        loads(dumps({1: 'A'}))
        >> {1: 'A'}
    """
    return cPickle.loads(s)
