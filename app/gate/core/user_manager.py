# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:37.
"""
from gfirefly.utils.singleton import Singleton


class UsersManager:

    __metaclass__ = Singleton

    def __init__(self):
        self._users = {}