# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:30.
"""


class User(object):
    """用户帳號类
    """

    def __init__(self, name, password, dynamic_id=-1):
        """ 初始化
        @param name:
        @param password:
        @param dynamic_id:
        """
        self.id = 0
        self.token = ''
        self.dynamic_id = dynamic_id
        self.name = name
        self.password = password
        self.character_id = 0