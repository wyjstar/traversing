# -*- coding:utf-8 -*-
"""
created by server on 14-6-23下午3:14.
"""
from shared.db_entrust.redis_object import RedisObject


class Character(RedisObject):

    def __init__(self, pid, name, mc):
        """
        @param pid:
        @param name:
        @param mc:
        @return:
        """
        RedisObject.__init__(self, name, mc)
        self.character_id = pid
        self.nickname = u''

    @property
    def character_info(self):
        keys = [key for key in self.__dict__.keys() if not key.startswith('_')]
        info = self.hmget(keys)
        return info
