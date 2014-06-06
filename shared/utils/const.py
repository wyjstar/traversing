# -*- coding:utf-8 -*-
"""
created by server on 14-6-4下午3:04.
"""


class ConstError(Exception):
    pass


class _const(object):
    """定义常量
    """

    def __setattr__(self, key, value):
        if key in self.__dict__:
            raise ConstError
        else:
            self.__dict__[key] = value


const = _const()

const.ACCOUNT_COMMAND = [1, 2, 3, 4]  # 帐号服务器命令编号