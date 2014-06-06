# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午10:01.
"""
import pyuuid


def get_uuid():
    return pyuuid.uuid1().get_hex()