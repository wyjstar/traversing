#!/usr/bin/env python
# -*- coding: utf-8 -*-
from battle_process import BattlePVPProcess, BattlePVEProcess
from battle_round import BattleUnit
from battle_round import BestSkill, FriendSkill
from configs_data.game_configs import monster_config, monster_group_config, stage_config, special_stage_config, language_config
import sys


def parse_input(battle_type):
    """docstring for parse_input"""
    all_lines = []
    with open("input.csv") as f:
        all_lines = f.readlines()

    red_units = {}
    blue_groups = []
    blue_units = {} # pvp
    stage = () #pve
    red_best_skill = None
    blue_best_skill = None
    friend_skill = None


    for i in range(len(all_lines)):
        if i == 0: continue
        eles = all_lines[i].split(',')

        if i == 1 and eles[1]:
            red_best_skill = BestSkill(0, eles[1])

        if i >= 2 and i <= 7:
            if not eles[0]: continue
            unit = BattleUnit(i-1, eles[1], eles[2], eles[3], eles[4], eles[5], eles[6], eles[7], eles[8], eles[9], eles[10], eles[11], eles[12], eles[13], eles[14]
                    , eles[15], eles[16], eles[17])
            red_units[i-1] = unit
        if i == 8:
            if not eles[0]: continue
            unit = BattleUnit(-1, eles[1], eles[2], eles[3], eles[4], eles[5], eles[6], eles[7], eles[8], eles[9], eles[10], eles[11], eles[12])
            friend_skill = FriendSkill(unit)

        if i == 10 and eles[1]:
            blue_best_skill = BestSkill(0, eles[1])

        if i >= 11 and i <= 16 and battle_type == "pvp":
            if not eles[0]: continue
            unit = BattleUnit(i-10, eles[1], eles[2], eles[3], eles[4], eles[5], eles[6], eles[7], eles[8], eles[9], eles[10], eles[11], eles[12])
            blue_units[i-10] = unit
            blue_groups.append(blue_units)


        if i == 19 and battle_type == "pve":
            stage = eles[1], eles[2]
            print "stage:", stage
            stage_info = get_stage_info(stage)
            if not stage_info: return
            blue_groups = get_monsters(stage_info)

            # todo: consturct monster group
    if battle_type == "pvp":
        return BattlePVPProcess(red_units, red_best_skill, blue_units, blue_best_skill)
    elif battle_type == "pve":
        return BattlePVEProcess(red_units, red_best_skill, blue_groups, friend_skill)

def get_stage_info(stage):
    """
    根据关卡获取ID
    """
    stage_name = stage[0]
    stage_type = stage[1]
    stage_type_id = 0
    if stage_type == "普通":
        stage_type_id = 1
    elif stage_type == "一般":
        stage_type_id = 2
    elif stage_type == "困难":
        stage_type_id = 3
    elif stage_type == "精英":
        stage_type_id = 6
    elif stage_type == "活动":
        stage_type_id = 5
    elif stage_type == "世界BOSS":
        stage_type_id = 7

    stage_name_id = None
    for k, v in language_config.items():
        if v.cn == stage_name:
            stage_name_id = k
            break
    if not stage_name_id:
        print "关卡:%s 不存在！" % stage_name
        return 0

    stage_info = None

    if stage_type_id in [1,2,3]:
        for k, v in stage_config.items():
            if v.name == stage_name_id and v.type == stage_type_id:
                stage_info = v
                break

    if stage_type_id in [5,6,7]:
        for k, v in special_stage_config.items():
            if v.name == stage_name_id and v.type == stage_type_id:
                stage_info = v
                break

    if not stage_info:
        print "关卡:%s-%s 不存在！" % (stage_name, stage_type)
        return 0
    return stage_info

def get_monsters(stage_info):
    """get monsters from configs."""
    blue_groups = []
    for i in [1,2,3]:
        monster_group_id = stage_info.get("round%d" % i)
        monster_group_info = monster_group_config.get(monster_group_id)
        blue_units = {}

        for j in [1,2,3,4,5,6]:
            monster_id = monster_group_info.get("pos%d" % j)
            if not monster_id: continue
            monster_info = monster_config.get(monster_id)
            unit = BattleUnit(j, "怪物"+str(j), monster_id, 0, monster_info.hp, monster_info.atk, monster_info.physicalDef, monster_info.magicDef, monster_info.hit,
                     monster_info.dodge, monster_info.cri, monster_info.cri_coeff, monster_info.cri_ded_coeff, monster_info.block)
            blue_units[j] = unit
        blue_groups.append(blue_units)

    return blue_groups

if __name__ == '__main__':
    battle_type = 'pve'
    if len(sys.argv) > 1:
        battle_type = sys.argv[1]
    process = parse_input(battle_type)
    process.process()



