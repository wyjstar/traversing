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

from test.init_data.mock_heros import init_hero
from test.init_data.mock_hero_chips import init_hero_chip
from test.init_data.mock_equipment import init_equipment
from test.init_data.mock_equipment_chip import init_equipment_chip
from test.init_data.mock_item import init_item
from test.init_data.mock_line_up import init_line_up
from test.init_data.mock_runt import init_runt
from test.init_data.mock_guild import init_guild
from test.init_data.mock_travel_item import init_travel_item
from test.init_data.mock_player import init_player


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


@remoteserviceHandle('gate')
def init_hero_remote(data, player):
    init_hero(player)
    return True


@remoteserviceHandle('gate')
def init_hero_chip_remote(data, player):
    init_hero_chip(player)
    return True


@remoteserviceHandle('gate')
def init_equipment_remote(data, player):
    init_equipment(player)
    return True


@remoteserviceHandle('gate')
def init_equipment_chip_remote(data, player):
    init_equipment_chip(player)
    return True


@remoteserviceHandle('gate')
def init_item_remote(data, player):
    init_item(player)
    return True
