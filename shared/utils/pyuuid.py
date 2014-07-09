# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午10:01.
"""
import uuid


def get_uuid():
    return uuid.uuid1().get_hex()


if __name__ == '__main__':
    print type(get_uuid())