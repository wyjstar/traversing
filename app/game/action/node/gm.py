# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info, tb_guild_name
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.game.core.item_group_helper import gain
from shared.utils.const import const
from shared.db_opear.configs_data.data_helper import parse
from test.init_data.init_data import init
from test.init_data.mock_heros import init_hero
from test.init_data.mock_hero_chips import init_hero_chip
from test.init_data.mock_equipment import init_equipment
from test.init_data.mock_equipment_chip import init_equipment_chip
from test.init_data.mock_item import init_item
import cPickle
# from app.proto_file.gm_pb2 import *
from shared.utils import trie_tree
import re


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def ban_user(data, player):
    args = cPickle.loads(data)
    player.base_info.gag = args['lock_time']
    player.base_info.save_data()
    return {'success': 1}


@remoteserviceHandle('gate')
def ban_speak(data, player):
    args = cPickle.loads(data)
    player.base_info.closure = args['lock_time']
    player.base_info.save_data()
    return {'success': 1}


@remoteserviceHandle('gate')
def modify_user_info(data, player):
    args = cPickle.loads(data)
    if args['attr_name'] == 'user_level':
        player.base_info.level = int(args['attr_value'])
        player.base_info.save_data()
        return {'success': 1}
    elif args['attr_name'] == 'vip_level':
        player.base_info.vip_level = int(args['attr_value'])
        player.base_info.save_data()
        return {'success': 1}
    elif args['attr_name'] == 'buy_stamina_times':
        player.stamina.buy_stamina_times = int(args['attr_value'])
        player.stamina.save_data()
        return {'success': 1}
    elif args['attr_name'] == 'stamina':
        player.finance._finances[7] = int(args['attr_value'])
        player.finance.save_data()
        return {'success': 1}
    elif args['attr_name'] == 'user_exp':
        player.base_info.exp = int(args['attr_value'])
        player.base_info.save_data()
        return {'success': 1}
    elif args['attr_name'] == 'nickname':
        nickname = args['attr_value']
        match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', nickname)
        if match:
            return {'success': 0, 'message': 2}

        if trie_tree.check.replace_bad_word(nickname) != nickname:
            return {'success': 0, 'message': 2}

        # 判断昵称是否重复
        nickname_obj = tb_character_info.getObj('nickname')
        result = nickname_obj.hsetnx(args['attr_value'], args['uid'])
        if result:
            player.base_info.base_name = args['attr_value']
            player.base_info.save_data()
            return {'success': 1}
        else:
            return {'success': 0, 'message': 0}

    else:
        return {'success': 0, 'message': 3}
    # push = GmCommonModifyLevel()
    # push.level = int(args['level'])
    # remote_gate.push_object_remote(850,
    #                                push.SerializeToString(),
    #                                [player.dynamic_id])


# ==========================================================


@remoteserviceHandle('gate')
def add_level_remote(data, player):
    logger.debug("add_level_remote")
    logger.debug(data)
    args = cPickle.loads(data)
    level = args.get('level')
    if not level and level.isdigit():
        return {'success': 0}
    level = int(level)
    if level > 200:
        level = 200

    player.base_info._level = level
    player.base_info.save_data()
    return {'success': 1}


@remoteserviceHandle('gate')
def gain_remote(data, player):
    args = cPickle.loads(data)
    gain_info= parse(eval(args.get('gain')))
    gain(player, gain_info, const.GM)
    return {'success': 1}


@remoteserviceHandle('gate')
def super_init_remote(data, player):
    init(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def add_vip_remote(data, player):
    args = cPickle.loads(data)
    level = args.get('level')
    if not level and level.isdigit():
        return {'success': 0}
    level = int(level)
    if level > 15:
        level = 15

    player.base_info.vip_level = level
    player.base_info.save_data()
    return {'success': 1}


@remoteserviceHandle('gate')
def init_hero_remote(data, player):
    init_hero(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def init_hero_chip_remote(data, player):
    init_hero_chip(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def init_equipment_remote(data, player):
    init_equipment(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def init_equipment_chip_remote(data, player):
    init_equipment_chip(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def init_item_remote(data, player):
    init_item(player)
    return {'success': 1}


@remoteserviceHandle('gate')
def add_guild_level_remote(data, player):
    args = cPickle.loads(data)
    level = int(args.get('level'))
    name = args.get('name')
    guild_name_data = tb_guild_name.getObj('names')
    guild_id = guild_name_data.hget(name)
    if not guild_id:
        logger.debug('guild name not find')
        return {'success': 0}

    guild_data = tb_guild_info.getObj(guild_id).hgetall()
    if not guild_data:
        logger.debug('guild name not find1')
        return 0
    if level > 10:
        level = 10
    guild_obj = Guild()
    guild_obj.init_data(guild_data)
    guild_obj.level = int(level)
    remote_gate.add_guild_to_rank_remote(guild_obj.g_id, guild_obj.level)
    guild_obj.save_data()
    return {'success': 1}
