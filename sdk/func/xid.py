# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" id相关扩展方法
"""

import hashlib
import uuid


def strid(_id, max_len, padding_chr='0'):
    """
    以padding_char补齐_id为maxlen位长的字符串

    Example:
        strid(12, 10)
        >> 0000000012
    """
    _id = str(_id)
    assert len(_id) <= max_len, "max_len less than id length"
    return padding_chr * (max_len - len(_id)) + _id


def hexmd5(txt):
    """
    获取32为长的MD5哈希值

    Example:
        hexmd5('a')
        >> 0cc175b9c0f1b6a831c399e269772661
    """
    return hashlib.new("md5", str(txt)).hexdigest()


def hexuuid():
    """
    获取32为长的UUID

    Example:
        hexuuid()
        >> 1aa1571e8f2711e4b36d685b35d36644
    """
    return uuid.uuid1().get_hex()


def sid(_id, max_len):
    _id = str(_id)
    assert len(_id) <= max_len, "max_len less than id length"
    return "0" * (max_len - len(_id)) + _id

def md5(txt):
    return hashlib.new("md5", str(txt)).hexdigest()
