# -*- coding:utf-8 -*-
"""
@author: cui
"""
import time
from app.world.redis_mode import tb_guild_info
from shared.common_logic.guild import Guild


class GuildManager(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._guilds = {}  # {id:obj}

    def get_guild_obj(self, g_id):
        """获取军团对象
        """
        guild_obj = self._guilds.get(g_id)
        if guild_obj:
            return guild_obj
        data = tb_guild_info.getObj(g_id).hgetall()
        if not data:
            return None
        else:
            guild_obj = Guild(tb_guild_info)
            guild_obj.init_data(data)
            self._guilds[g_id] = guild_obj
            return guild_obj

    def create_guild(self, p_id, g_name, icon_id):
        guild_obj = Guild(tb_guild_info)
        guild_obj.create_guild(p_id, g_name, icon_id)
        self._guilds[guild_obj.g_id] = guild_obj
        return guild_obj

guild_manager_obj = GuildManager()
