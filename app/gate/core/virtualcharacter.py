# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午2:55.
"""


class VirtualCharacter:
    """
    虚拟角色类，记录角色对应的游戏服务器
    """
    def __init__(self, characterid, dynamicid, node="game"):
        """
        :param characterid: character id
        :param dynamicid: connection id
        :param node: 游戏服务器

        :attribute locked: character lock status
        """
        self._character_id = characterid
        self._dynamic_id = dynamicid
        self._node = node
        self._locked = False

    @property
    def characterid(self):
        return self._character_id

    @characterid.setter
    def characterid(self, value):
        self._character_id = value

    @property
    def dynamicid(self):
        return self._dynamic_id

    @dynamicid.setter
    def dynamicid(self, value):
        self._dynamic_id = value

    @property
    def node(self):
        return self._node

    @node.setter
    def node(self, value):
        self._node = value