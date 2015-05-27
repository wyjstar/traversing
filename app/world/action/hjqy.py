#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.hjqy_boss import hjqy_manager
from app.world.core.mine_boss import mine_boss_manager
from app.battle.server_process import hjqy_start
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.world.action.gateforwarding import push_all_object_message
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data import game_configs
from shared.utils.const import const
from app.world.action.gateforwarding import push_all_object_message
#from app.proto_file import line_up_pb2

@rootserviceHandle
def hjqy_init_remote(player_id, friend_ids):
    """
    初始化信息
    """
    bosses = {}
    for temp_id in friend_ids + [player_id]:
        boss = hjqy_manager.get_boss(temp_id)
        if boss and (boss.is_share or temp_id == temp_id): #获取hjqy列表
            bosses[player_id] = dict(player_id=boss.player_id,
                    stage_id=boss.stage_id,
                    is_share=boss.is_share,
                    trigger_time=boss.trigger_time,
                    hp_max=boss.hp_max,
                    hp_left=boss.hp,
                    state=boss.get_state()
                    )
    return bosses

@rootserviceHandle
def hjqy_damage_hp_remote(player_id):
    """ 获取玩家伤害信息
    """
    return hjqy_manager.get_damage_hp(player_id, 0)

@rootserviceHandle
def share_hjqy_remote(player_id):
    """分享
    """
    boss = hjqy_manager.get_boss(player_id)
    if not boss:
        return False
    boss.is_share = True

    push_all_object_message(2112,"")
    return True

#def hjqy_start(red_units,  blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, attack_type, seed1, seed2, level):
@rootserviceHandle
def hjqy_battle_remote(boss_id, red_units, red_best_skill_id, red_best_skill_level, attack_type, seed1, seed2, player_level):
    """开始战斗
    """
    result = False
    boss = hjqy_manager.get_boss(boss_id)
    blue_units = boss.blue_units

    result = hjqy_start(red_units,  blue_units, red_best_skill_id, red_best_skill_level, 0, 1, attack_type, seed1, seed2, player_level)

    blue_units = result.get("blue_units")
    boss.blue_units = blue_units

    if boss.get_state() == const.BOSS_DEAD:
        # todo: send last kill reward mail
        result = True
    return dict(result=result, state=boss.state)

@rootserviceHandle
def blue_units_remote(boss_id):
    """
    blue_units
    """
    boss = hjqy_manager.get_boss(boss_id)
    return boss.blue_units

@rootserviceHandle
def is_can_trggere_hjqy_remote(player_id):
    """
    玩家是否可触发hjqy
    """
    boss = hjqy_manager.get_boss(player_id)
    if not boss:
        return True
    if boss.get_state() != const.BOSS_LIVE:
        return False
    return True

@rootserviceHandle
def create_hjqy_remote(player_id, blue_units, stage_id):
    """
    触发hjqy
    """
    hjqy_manager.add_boss(player_id, blue_units, stage_id)
    return True
