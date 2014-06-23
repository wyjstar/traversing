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

        if user.user_id in self._users:
            self._users[user.user_id].disconnect()
            self.drop_by_id(user.user_id)
        self._users[user.user_id] = user

    def drop_user(self, user):
        user_id = user.user_id
        if user_id in self._users:
            del self._users[user_id]

    def get_by_id(self, user_id):
        return self._users.get(user_id)

    def drop_by_id(self, user_id):
        """ 根据用户ID处理用户下线
        @param user_id:
        @return:
        """
        user = self.get_by_id(user_id)
        if user:
            self.drop_user(user)
    #
    #
    # def addUser(self, user):
    #     """添加一个用户
    #     """
    #     if self._users.has_key(user.id):
    #         self._users[user.id].disconnectClient()
    #         self.dropUserByID(user.id)
    #     self._users[user.id] = user
    #
    # def getUserByID(self, uid):
    #     """根据ID获取用户信息
    #     """
    #     return self._users.get(uid)
    #
    # def getUserByDynamicId(self,dynamicId):
    #     '''根据客户端的动态ID获取user实例'''
    #     for user in self._users.values():
    #         if user.dynamicId==dynamicId:
    #             return user
    #     return None
    #
    # def getUserByUsername(self, username):
    #     """根据用户名获取用户信息
    #     """
    #     for k in self._users.values():
    #         if k.getNickName() == username:
    #             return k
    #     return None
    #
    #
    # def dropUserByDynamicId(self, dynamicId):
    #     user = self.getUserByDynamicId(dynamicId)
    #     if user:
    #         self.dropUser(user)
    #