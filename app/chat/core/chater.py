# -*- coding:utf-8 -*-
"""
created by server on 14-5-19上午10:31.
"""
import time
from gfirefly.dbentrust.redis_mode import RedisObject


tb_character_info = RedisObject('tb_character_info')


class Chater(object):
    """聊天成员类
    """

    def __init__(self, character_id, dynamic_id=-1, guild_id=0, name=u''):
        """初始化
        @param character_id: int 角色的id
        @param name: str 角色的名称
        @param dynamic_id: int 聊天客户端的ID
        """
        self._character_id = character_id
        self._name = name
        self._dynamic_id = dynamic_id
        self._room_id = 1  # 房间号ID
        self._island = True  # 是否在线  False表示离线,True表示在线
        self._guild_id = guild_id
        self._last_time = 1
        char_obj = tb_character_info.getObj(self._character_id)
        self._bad_words_times = char_obj.hget('say_bad_words_times', [])

    def say_bad_words_once(self):
        now_time = time.time()
        self._bad_words_times.append(now_time)
        # self._bad_words_times = filter(lambda x: x > now_time-60*60,
        #                                self._bad_words_times)
        char_obj = tb_character_info.getObj(self._character_id)
        char_obj.hset('say_bad_words_times', self._bad_words_times)

    def clear_say_bad_words(self):
        self._bad_words_times = []
        # self._bad_words_times = filter(lambda x: x > now_time-60*60,
        #                                self._bad_words_times)
        char_obj = tb_character_info.getObj(self._character_id)
        char_obj.hset('say_bad_words_times', self._bad_words_times)

    def say_bad_words_times(self):
        # now_time = time.time()
        # self._bad_words_times = filter(lambda x: x > now_time-60*60,
        #                                self._bad_words_times)
        return len(self._bad_words_times)

    @property
    def character_id(self):
        return self._character_id

    @character_id.setter
    def character_id(self, character_id):
        self._character_id = character_id

    @property
    def name(self):
        return self._name

    @name.setter
    def name(self, name):
        self._name = name

    @property
    def dynamic_id(self):
        return self._dynamic_id

    @dynamic_id.setter
    def dynamic_id(self, dynamic_id):
        self._dynamic_id = dynamic_id

    @property
    def room_id(self):
        return self._room_id

    @room_id.setter
    def room_id(self, room_id):
        self._room_id = room_id

    @property
    def island(self):
        return self._island

    @island.setter
    def island(self, island):
        self._island = island

    @property
    def guild_id(self):
        return self._guild_id

    @guild_id.setter
    def guild_id(self, guild_id):
        self._guild_id = guild_id

    @property
    def last_time(self):
        return self._last_time

    @last_time.setter
    def last_time(self, last_time):
        self._last_time = last_time
