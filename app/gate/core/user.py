# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:30.
"""
from app.gate.redis_mode import tb_character_info
import time


class User(object):
    """用户帐号类
    """

    def __init__(self, token, user_id, name='', password='', dynamic_id=-1):
        """ 初始化
        @param token: 用户登录用
        @param dynamic_id: 客户端动态ID
        """
        self._dynamic_id = dynamic_id
        self._token = token
        self._user_id = user_id
        self._name = name
        self._password = password
        self._character = {}
        self._is_effective = True  # 是否是有效的

    def create_character(self):
        pass

    def disconnect(self):
        pass

    @property
    def user_id(self):
        return self._user_id

    @user_id.setter
    def user_id(self, user_id):
        self._user_id = user_id

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @property
    def is_effective(self):
        return self._is_effective

    @is_effective.setter
    def is_effective(self, is_effective):
        self._is_effective = is_effective

    @property
    def password(self):
        return self.password

    @password.setter
    def password(self, password):
        self._password = password

    @property
    def character(self):
        character = self._character

        return character

    @character.setter
    def character(self, character):
        print 'character:', character
        self._character = character
        pmmode = tb_character_info.getObj(self._character.get('id'))
        pmmode.hmset(self._character)

    @property
    def token(self):
        return self._token

    @token.setter
    def token(self, token):
        self._token = token

    @property
    def dynamic_id(self):
        return self._dynamic_id

    @dynamic_id.setter
    def dynamic_id(self, dynamic_id):
        self._dynamic_id = dynamic_id
