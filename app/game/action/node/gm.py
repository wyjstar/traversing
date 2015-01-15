# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
import re
import time
from app.game.core.PlayersManager import PlayersManager
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info, tb_guild_name
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data.game_configs import guild_config
from shared.db_opear.configs_data.game_configs import base_config
from shared.utils import trie_tree
import cPickle
from app.game.core.item_group_helper import gain
from shared.utils.const import const
from shared.db_opear.configs_data.data_helper import parse
from test.init_data.init_data import init


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def add_level_remote(data, player):
    args = cPickle.loads(data)
    level = args.get('level')
    if not level and level.isdigit():
        return False
    level = int(level)
    if level > 200:
        level = 200

    player.base_info.level = level
    player.base_info.save_data()
    return True


@remoteserviceHandle('gate')
def gain_remote(data, player):
    args = cPickle.loads(data)
    gain_info= parse(eval(args.get('gain')))
    gain(player, gain_info, const.GM)
    return True


@remoteserviceHandle('gate')
def super_init_remote(data, player):
    init(player)
    return True


@remoteserviceHandle('gate')
def add_vip_remote(data, player):
    args = cPickle.loads(data)
    level = args.get('level')
    if not level and level.isdigit():
        return False
    level = int(level)
    if level > 15:
        level = 15

    player.base_info.vip_level = level
    player.base_info.save_data()
    return True
