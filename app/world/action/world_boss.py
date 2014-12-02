#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.world_boss import world_boss
from app.battle.battle_process import BattlePVBProcess
import cPickle


@rootserviceHandle
def pvb_get_before_fight_info_remote(player_id):
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    5. 关卡id
    """
    response = world_boss_pb2.PvbBeforeInfoResponse()
    for hero_no in world_boss.lucky_high_heros:
        response.lucky_high_heros.append(hero_no)
    for hero_no in world_boss.lucky_middle_heros:
        response.lucky_middle_heros.append(hero_no)
    for hero_no in world_boss.lucky_low_heros:
        response.lucky_low_heros.append(hero_no)

    # 返回伤害前十名
    for rank_item in world_boss.get_rank_items():
        rank_item_pb = response.rank_items.add()
        update_rank_items(rank_item_pb, rank_item)

    # 最后击杀
    update_rank_items(response.last_shot_item, world_boss.last_shot_item)

    # 奇遇
    response.debuff_skill_no = world_boss.debuff_skill_no
    # 关卡id
    response.stage_id = world_boss.stage_id
    # 是否开启
    response.open_or_not = world_boss.open_or_not
    # 剩余血量
    response.hp_left = int(world_boss.hp)
    # 伤害
    response.demage_hp = int(world_boss.get_demage_hp(player_id))
    # 名次
    response.rank_no = world_boss.get_rank_no(player_id)


    return response.SerializeToString()

def update_rank_items(rank_item_pb, rank_item):
    rank_item_pb.nickname = rank_item.get("nickname", "")
    rank_item_pb.level = rank_item.get("level", 0)
    rank_item_pb.first_hero_no = rank_item.get("first_hero_no", 0)
    rank_item_pb.demage_hp = int(rank_item.get("demage_hp", 0))

@rootserviceHandle
def pvb_fight_remote(str_red_units, red_best_skill, str_blue_units, player_info):
    red_units = cPickle.loads(str_red_units)
    blue_units = cPickle.loads(str_blue_units)
    process = BattlePVBProcess(red_units, player_info.get("level"), red_best_skill,  blue_units, world_boss.debuff_skill_no)
    result, hp_left = process.process()

    # 保存worldboss数据
    world_boss.hp = hp_left

    # 保存排行和玩家信息
    demage_hp = blue_units.get(5).hp - hp_left # 伤害血量
    first_hero_no = red_units.values()[0].unit_no # 第一个武将no，用于显示头像
    player_info["first_hero_no"] = first_hero_no
    player_info["demage_hp"] = demage_hp
    world_boss.add_rank_item(player_info)

    # 如果赢了，保存最后击杀
    if result:
        world_boss.last_shot_item = player_info
        world_boss.update_boss()

    world_boss.save_data()
    return result

@rootserviceHandle
def pvb_player_info_remote(no):
    """
    获取玩家阵容信息
    no为玩家排名
    """
    return world_boss.get_rank_item_by_rankno(no).get("line_up_info")



