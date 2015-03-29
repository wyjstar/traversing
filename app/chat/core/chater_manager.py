#-*- coding:utf-8 -*-
"""
created by server on 14-5-19上午10:54.
"""

from gfirefly.utils.singleton import Singleton


class ChaterManager(object):
    """聊天成员管理
    """

    __metaclass__ = Singleton

    def __init__(self):
        self._chaters = {}  # 在线成员
        self.mapping = {}  # 动态id 对应 角色id
        self.guild = {}
        self.gag_time = 1

    def get_guild_dynamicid(self, guild_id):
        """获取公会成员的动态id
        """
        ids = self.guild.get(guild_id)
        if ids:
            return ids
        return []

    def getall_dynamicid(self):
        """获取所有在线角色的动态id
        """
        return self.mapping.keys()

    def getid_by_dynamicid(self, dynamic_id):
        """根据动态id获取角色聊天类id
        """
        if dynamic_id in self.mapping:
            return self.mapping[dynamic_id]
        return None

    def add_chater(self, chater):
        """添加一个成员到在线聊天成员列表中
        """
        if self._chaters.has_key(chater.chater_id):
            raise Exception("系统记录冲突")
        self._chaters[chater.chater_id] = chater

    def addchater_by_id(self, chater_id):
        """添加角色聊天类，如果有了返回存在角色聊天类
        """
        from app.chat.core.chater import Chater

        chater = self._chaters.get(chater_id, None)
        if not chater:
            chater = Chater(chater_id)
            self._chaters[chater_id] = chater
        return chater


    def getchater_by_id(self, chater_id):
        """根据角色的id得到聊天成员
        """

        if chater_id in self._chaters:
            return self._chaters[chater_id]
        return None

    def update_onland(self, chater_id, dynamic_id, guild_id, gag_time):
        """设置角色登陆
        @param chater_id: int 角色id
        @param dynamic_id: int 动态id
        """
        chater = self._chaters[chater_id]
        chater.island = True
        chater.dynamic_id = dynamic_id
        chater.gag_time = gag_time
        self.mapping[dynamic_id] = chater_id  #动态id对应角色id
        if guild_id:
            if not self.guild.get(guild_id):
                self.guild[guild_id] = []
            if self.guild[guild_id].count(dynamic_id) == 0:
                self.guild[guild_id].append(dynamic_id)

    def update_outland(self, chater_id, dynamic_id, guild_id):
        """设置角色下线
        @param chater_id: int 角色id
        @param dynamic_id: int 动态id
        """
        chater = self._chaters[chater_id]
        chater.island = False
        chater.dynamic_id = -1
        del self.mapping[dynamic_id]  #删除这个动态id与角色id的对应关系
        del self._chaters[chater_id]
        if guild_id:
            if self.guild.get(guild_id):
                if self.guild[guild_id].count(dynamic_id):
                    self.guild[guild_id].remove(dynamic_id)

    def join_room(self, dynamic_id, guild_id):
        """加入公会房间
        """
        if not self.guild.get(guild_id):
            self.guild[guild_id] = []
        self.guild[guild_id].append(dynamic_id)

    def leave_room(self, dynamic_id, guild_id):
        """退出公会房间
        """
        if self.guild.get(guild_id):
            if self.guild[guild_id].count(dynamic_id):
                self.guild[guild_id].remove(dynamic_id)
