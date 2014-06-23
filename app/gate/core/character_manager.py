# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:38.
"""
from gfirefly.utils.singleton import Singleton
from gtwisted.utils import log


class VCharacterManager:
    """角色管理器
    """

    __metaclass__ = Singleton

    def __init__(self):
        """记录角色ID与客户端id的关系
        """
        self.character_client = {}
        self.client_character = {}

    def add_character(self, v_character):
        character_id = v_character.character_id
        self.character_client[character_id] = v_character
        self.client_character[v_character.dynamic_id] = v_character

    def get_by_id(self, character_id):
        return self.character_client.get(character_id)

    # def get_character_by_clientid(self, clientid):
    #     return self.client_character.get(clientid)

    # def drop_character_by_clientid(self, clientid):
    #     """
    #     下线时删除character
    #     :param clientid: dynamicid
    #     :return:
    #     """
    #     character = self.get_character_by_clientid(clientid)
    #     try:
    #         del self.character_client[character.characterid]
    #     finally:
    #         pass
    #     try:
    #         del self.client_character[character.dynamicid]
    #     finally:
    #         pass
    #
    # def drop_character_by_characterid(self, characterid):
    #     """
    #     下线时删除character
    #     :param characterid: characterid
    #     :return:
    #     """
    #     character = self.get_character_by_characterid(characterid)
    #     try:
    #         del self.character_client[character.characterid]
    #     finally:
    #         pass
    #     try:
    #         del self.client_character[character.dynamicid]
    #     finally:
    #         pass
    #
    # def get_node_by_characterid(self, characterid):
    #     character = self.character_client.get(characterid)
    #     if character:
    #         return character.node
    #     return -1
    #
    # def get_node_by_clientid(self, clientid):
    #     character = self.client_character.get(clientid)
    #     if character:
    #         return character.node
    #     return -1
    #
    # def get_clientid_by_characterid(self, characterid):
    #     character = self.character_client.get(characterid)
    #     if character:
    #         return character.dynamicid
    #     return -1
    #
    # def get_character_id_by_clientid(self, clientid):
    #     character = self.client_character.get(clientid)
    #     if character:
    #         return character.characterid
    #     return -1





