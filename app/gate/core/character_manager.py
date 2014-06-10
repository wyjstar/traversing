# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:38.
"""
from gfirefly.utils.singleton import Singleton


class VCharacterManager:
    """角色管理器
    """

    __metaclass__ = Singleton

    def __init__(self):
        """记录角色ID与客户端id的关系
        """
        self.character_client = {}
        self.client_character = {}