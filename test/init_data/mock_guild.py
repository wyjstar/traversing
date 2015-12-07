# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from app.proto_file.guild_pb2 import *
from shared.db_opear.configs_data import game_configs
from gfirefly.server.globalobject import GlobalObject


remote_gate = GlobalObject().remote.get('gate')


def init_guild(player):
    return

    guild_obj = Guild()
    guild_obj.create_guild(player.base_info.id, '自动生成')

    player.guild.g_id = guild_obj.g_id
    player.guild.worship = 0
    player.guild.worship_time = 1
    player.guild.contribution = 0
    player.guild.all_contribution = 0
    player.guild.k_num = 0
    player.guild.position = 1
    player.guild.save_data()

    guild_obj.level = 7
    guild_obj.save_data()
    player.finance.save_data()

    remote_gate.add_guild_to_rank_remote(guild_obj.g_id, guild_obj.level)

    # 加入公会聊天
    remote_gate.login_guild_chat_remote(player.dynamic_id, player.guild.g_id)
