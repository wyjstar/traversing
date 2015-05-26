#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.world_boss import world_boss
from app.world.core.mine_boss import mine_boss_manager
from app.battle.server_process import world_boss_start
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
#from app.proto_file import line_up_pb2

@rootserviceHandle
def hjqy_init_remote(friend_ids):
    """
    初始化信息
    """
    pass


@rootserviceHandle
def hjqy_damage_hp_remote(player_id):
    """ 获取玩家伤害信息
    """
    pass


@rootserviceHandle
def share_hjqy_remote(player_id):
    """分享
    """
    pass

@rootserviceHandle
def hjqy_battle_remote(player_id):
    """开始战斗
    """
    pass
