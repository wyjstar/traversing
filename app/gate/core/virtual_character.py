# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午2:55.
"""


class VirtualCharacter:
    """
    虚拟角色类，记录角色对应的游戏服务器
    """
    def __init__(self, character_id, dynamic_id, node=''):
        """
        @param character_id: character id
        @param dynamic_id: connection id
        @param node: 游戏服务器
        """
        self._character_id = character_id
        self._dynamic_id = dynamic_id
        self._node = node
        self._locked = False

    @property
    def character_id(self):
        return self._character_id

    @character_id.setter
    def character_id(self, value):
        self._character_id = value

    @property
    def dynamic_id(self):
        return self._dynamic_id

    @dynamic_id.setter
    def dynamic_id(self, value):
        self._dynamic_id = value

    @property
    def node(self):
        return self._node

    @node.setter
    def node(self, value):
        self._node = value

    @property
    def locked(self):
        return self._locked

    @locked.setter
    def locked(self, locked):
        self._locked = locked