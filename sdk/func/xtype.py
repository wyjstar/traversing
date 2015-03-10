# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" type相关扩展方法
"""


def evalbytype(stype, val):
    """
    把val转换为stype指定的类型
    @param stype: INT, STR, FLOAT, LIST, DICT...
    """
    if stype == 'INT':
        return int(val)
    elif stype == 'STR':
        return str(val)
    elif stype == 'FLOAT':
        return float(val)
    elif stype == 'LIST':
        return eval(val)
    elif stype == 'DICT':
        return eval(val)


def bytestoint(bs):
    """
    四位字节转换为int

    Example:
        bytestoint('\x00\x00\x01\x01')
        >> 257
    """
    n = 0
    n += (ord(bs[0]) << 24)
    n += (ord(bs[1]) << 16)
    n += (ord(bs[2]) << 8)
    n += (ord(bs[3]))
    return n


def inttobytes(n):
    """
    int转换为四位字节

    Example:
        repr(inttobytes(257))
        >> '\x00\x00\x01\x01'
    """
    bs = [chr((n >> 24) & 0xff), chr((n >> 16) & 0xff), chr((n >> 8) & 0xff), chr(n & 0xff)]
    return ''.join(bs)


