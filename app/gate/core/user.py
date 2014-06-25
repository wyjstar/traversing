# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午5:30.
"""
from app.gate.redis_mode import tb_account, tb_character_info, tb_account_mapping

class User(object):
    """用户帐号类
    """

    def __init__(self, token, dynamic_id=-1):
        """ 初始化
        """
        self._dynamic_id = dynamic_id
        self._token = token
        self._user_id = 0
        self._name = ''
        self._password = ''
        self._is_effective = True  # 是否是有效的
        self._character = {}

    def init_user(self):
        """初始化用户类
        """

        mapping_data = tb_account_mapping.getObjData(self.token)

        if not mapping_data:
            self.is_effective = False
            return

        user_id = mapping_data.get('id')

        account_data = tb_account.getObjData(user_id)
        # TODO 帐号表需要添加enable,做帐号开关
        self.user_id = user_id
        self.name = mapping_data.get('name', '')
        self.password = mapping_data.get('account_password', '')

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
        if not character:
            print 'user_id:', self.user_id
            character = tb_character_info.getObjData(self.user_id)
            if not character:
                character = {'uid': self.user_id, 'nickname': ''}
                character_obj = tb_character_info.new(character)
                character_obj.insert()
                self.character = character
        return character

    @character.setter
    def character(self, character):
        self._character = character
        pmmode = tb_character_info.getObj(self._character.get('uid'))
        pmmode.update_multi(self._character)

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