#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2
from app.world.core.world_boss import world_boss
from app.battle.battle_process import BattlePVBProcess


@rootserviceHandle
def pvb_get_before_fight_info_remote():
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    """
    response = world_boss_pb2.PvbGetBeforeFightResponse()
    for hero_no in world_boss.lucky_high_heros:
        response.lucky_high_heros.add(hero_no)
    for hero_no in world_boss.lucky_middle_heros:
        response.lucky_middle_heros.add(hero_no)
    for hero_no in world_boss.lucky_low_heros:
        response.lucky_low_heros.add(hero_no)

    # 返回伤害前十名
    for rank_item in world_boss.get_rank_items():
        rank_item_pb = response.rank_items.add()
        update_rank_items(rank_item_pb, rank_item)

    # 最后击杀
    update_rank_items(response.last_shot_item, world_boss.last_shot_item)

    response.debuff_skill_no = world_boss.debuff_skill_no
    return response.SerializeToString()

def update_rank_items(rank_item_pb, rank_item):
    rank_item_pb.nickname = rank_item.nickname
    rank_item_pb.level = rank_item.level
    rank_item_pb.first_hero_no = rank_item.first_hero_no
    rank_item_pb.demage_hp = rank_item.demage_hp

@rootserviceHandle
def pvb_fight_remote(red_units, red_best_skill, blue_units, nickname, level):
    process = BattlePVBProcess(red_units, red_best_skill, blue_units)
    result, hp_left = process.process()

    # 保存worldboss数据
    world_boss.hp = hp_left
    world_boss.open_or_not = (not result)

    # 保存排行
    demage_hp = blue_units.get(5).hp - hp_left # 伤害血量
    first_hero_no = red_units.values()[0].unit_no # 第一个武将no，用于显示头像
    rank_item = dict(nickname=nickname, level=level, first_hero_no=first_hero_no, demage_hp=demage_hp)
    world_boss.add_rank_item(rank_item)

    # 如果赢了，保存最后击杀
    if result:
        rank_item = dict(nickname=nickname, level=level, first_hero_no=first_hero_no, demage_hp=demage_hp)
    world_boss.save_data()
    return {"result":result, "hp_left":hp_left}


