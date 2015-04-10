# -*- coding:utf-8 -*-
"""
created by server on 14-6-23上午11:14.
"""
from gfirefly.utils.singleton import Singleton


class UsersManager:

    __metaclass__ = Singleton

    def __init__(self):
        self._users = {}  # {'user_id':user_obj}

    def add_user(self, user):
        """添加用户对象
        """
        if user.user_id in self._users:
            self._users[user.user_id].disconnect()
            self.drop_by_id(user.user_id)
        self._users[user.user_id] = user

    def get_by_id(self, user_id):
        """根据用户ID取得user实例
        """
        return self._users.get(user_id)

    def drop_by_id(self, user_id):
        """ 根据用户ID处理用户下线
        @param user_id:
        @return:
        """
        user = self.get_by_id(user_id)
        if user:
            self.drop_user(user)

    def get_by_dynamic_id(self, dynamic_id):
        """根据客户端的动态ID获取user实例
        """
        for user in self._users.values():
            if user.dynamic_id == dynamic_id:
                return user
        return None

    def get_by_user_name(self, user_name):
        """根据用户名获取用户信息
        """
        for user in self._users.values():
            if user.name == user_name:
                return user
        return None

    def drop_user(self, user):
        """删除user实例
        """
        user_id = user.user_id
        if user_id in self._users:
            del self._users[user_id]

    def drop_by_dynamic_id(self, dynamic_id):
        """根据动态ID删除user势力
        """
        user = self.get_by_dynamic_id(dynamic_id)
        if user:
            self.drop_user(user)

    def get_online_num(self):
        return len(self._users)
