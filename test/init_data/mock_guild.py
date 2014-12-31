# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_name
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils.pyuuid import get_uuid


def init_guild(player):

    uuid = get_uuid()
    guild_obj = Guild()
    guild_obj.create_guild(p_id, uuid)

    remote_gate.add_guild_to_rank_remote(guild_obj.g_id, 1)

    data = {'g_name': g_name,
            'g_id': guild_obj.g_id}
    tb_guild_name.new(data)

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
    player.finance.gold -= base_config.get('create_money')
    player.finance.save_data()
