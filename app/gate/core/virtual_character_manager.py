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
        self.character_client = {}  # {'character_id': v_character obj}
        self.client_character = {}  # {'dynamic_id': 'character_id'}

    def add_character(self, v_character):
        """添加
        """
        character_id = v_character.character_id
        self.character_client[character_id] = v_character
        self.client_character[v_character.dynamic_id] = character_id

    def get_by_id(self, character_id):
        return self.character_client.get(character_id)

    def get_by_dynamic_id(self, dynamic_id):
        character_id = self.client_character.get(dynamic_id)
        print("client_character keys %s %s" % (self.client_character.keys(), character_id))
        return self.get_by_id(character_id)

    def update_dynamic_id(self, old_dynamic_id, vcharacter):
        if old_dynamic_id in self.client_character:
            del self.client_character[old_dynamic_id]
        self.client_character[vcharacter.dynamic_id] = vcharacter.character_id

    def drop_by_dynamic_id(self, dynamic_id):
        """
        """
        character = self.get_by_dynamic_id(dynamic_id)
        try:
            del self.character_client[character.character_id]
        finally:
            pass
        try:
            del self.client_character[dynamic_id]
        finally:
            pass

    def drop_by_id(self, character_id):
        """
        """
        character = self.get_by_id(character_id)
        try:
            del self.character_client[character.character_id]
        finally:
            pass
        try:
            del self.client_character[character.dynamic_id]
        finally:
            pass

    def get_node_by_dynamic_id(self, dynamic_id):
        character = self.get_by_dynamic_id(dynamic_id)
        if character:
            return character.node
        return -1





