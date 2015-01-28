#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.world_boss import world_boss
from app.world.core.mine_boss import mine_boss_manager
from app.battle.battle_process import BattlePVBProcess
import cPickle
from shared.utils.date_util import get_current_timestamp
from app.world.action.gateforwarding import push_all_object_message


@rootserviceHandle
def pvb_get_before_fight_info_remote(player_id, boss_id):
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    5. 关卡id
    """
    boss = get_boss(boss_id)
    print "boss ", boss
    response = world_boss_pb2.PvbBeforeInfoResponse()
    for hero_no in boss.lucky_high_heros:
        response.lucky_high_heros.append(hero_no)
    for hero_no in boss.lucky_middle_heros:
        response.lucky_middle_heros.append(hero_no)
    for hero_no in boss.lucky_low_heros:
        response.lucky_low_heros.append(hero_no)

    # 返回伤害前十名
    for rank_item in boss.get_rank_items():
        rank_item_pb = response.rank_items.add()
        update_rank_items(rank_item_pb, rank_item)

    # 最后击杀
    update_rank_items(response.last_shot_item, boss.last_shot_item)

    # 奇遇
    response.debuff_skill_no = boss.debuff_skill_no
    # 关卡id
    response.stage_id = boss.stage_id
    # 是否开启
    response.open_or_not = boss.open_or_not
    # 剩余血量
    response.hp_left = int(boss.hp)
    # 伤害
    response.demage_hp = int(boss.get_demage_hp(player_id))
    # 名次
    response.rank_no = boss.get_rank_no(player_id)
    print response

    return response.SerializeToString()

def update_rank_items(rank_item_pb, rank_item):
    rank_item_pb.nickname = rank_item.get("nickname", "")
    rank_item_pb.level = rank_item.get("level", 0)
    rank_item_pb.first_hero_no = rank_item.get("first_hero_no", 0)
    rank_item_pb.demage_hp = int(rank_item.get("demage_hp", 0))

@rootserviceHandle
def pvb_fight_remote(str_red_units, red_best_skill, str_blue_units, player_info, boss_id):
    """
    战斗
    """
    boss = get_boss(boss_id)
    red_units = cPickle.loads(str_red_units)
    blue_units = cPickle.loads(str_blue_units)
    process = BattlePVBProcess(red_units, player_info.get("level"), red_best_skill,  blue_units, boss.debuff_skill_no)
    result, hp_left = process.process()

    # 保存worldboss数据
    boss.hp = hp_left

    # 保存排行和玩家信息
    demage_hp = blue_units.get(5).hp - hp_left # 伤害血量
    first_unit = red_units.values()[0]
    first_hero_no = first_unit.unit_no # 第一个武将no，用于显示头像
    if first_unit.is_awake:
        first_hero_no = first_unit.origin_no

    player_info["first_hero_no"] = first_hero_no
    player_info["demage_hp"] = demage_hp
    boss.add_rank_item(player_info)

    # 如果赢了，保存最后击杀
    if result:
        boss.last_shot_item = player_info
        boss.boss_dead_time = get_current_timestamp()

    boss.save_data()
    return result

@rootserviceHandle
def pvb_player_info_remote(no, boss_id):
    """
    获取玩家阵容信息
    no为玩家排名
    """
    boss = get_boss(boss_id)
    return boss.get_rank_item_by_rankno(no).get("line_up_info")

def get_boss(boss_id):
    """docstring for get_boss_id"""
    if boss_id == "world_boss":
        return world_boss
    else:
        return mine_boss_manager.get(boss_id)

@rootserviceHandle
def mine_get_boss_num_remote():
    return mine_boss_manager.get_boss_num()

@rootserviceHandle
def trigger_mine_boss_remote():
    """
    触发boss
    """
    if mine_boss_manager.get_boss_num() >= 1:
        return False
    boss_id, boss = mine_boss_manager.add()
    response = world_boss_pb2.MineBossResponse()
    response.res.result = True
    response.boss_id = boss_id
    response.stage_id = boss.stage_id
    print response

    push_all_object_message(1707, response.SerializeToString())
    return True
