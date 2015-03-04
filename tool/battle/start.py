#!/usr/bin/env python
# -*- coding: utf-8 -*-

from app.battle.battle_process import BattlePVPProcess, BattlePVEProcess
from app.battle.battle_unit import BattleUnit, do_assemble
from app.battle.battle_skill import FriendSkill
from shared.db_opear.configs_data import game_configs
import sys


def parse_input(battle_type):
    """docstring for parse_input"""
    all_lines = []
    with open("tool/battle/input.csv") as f:
        all_lines = f.readlines()

    red_units = {}
    blue_groups = []
    blue_units = {} # pvp
    stage = () #pve
    red_best_skill_no = 0
    red_player_level = 0
    blue_best_skill_no = 0
    blue_player_level = 0
    friend_skill = None


    for i in range(len(all_lines)):
        i = i-1
        if i == 0: continue
        eles = all_lines[i].split(',')

        if i == 1 and eles[1]:
            red_best_skill_no = int(eles[1])
            red_player_level = int(eles[2])

        if i >= 2 and i <= 7:
            if not eles[0]: continue
            unit = init_unit(i-1, eles)
            red_units[i-1] = unit
        if i == 8:
            if not eles[0]: continue
            unit = init_unit(-1, eles, is_hero=True)
            friend_skill = FriendSkill(unit)

        if i == 10 and eles[1]:
            blue_best_skill_no = int(eles[1])
            blue_player_level = int(eles[2])

        if i >= 11 and i <= 16 and battle_type == "pvp":
            if not eles[0]: continue
            unit = init_unit(i-10, eles)
            blue_units[i-10] = unit
            blue_groups.append(blue_units)


        if i == 19 and battle_type == "pve":
            stage = eles[1], eles[2]
            print "stage:", stage
            stage_info = get_stage_info(stage)
            if not stage_info: return
            blue_groups = get_monsters(stage_info)

    if battle_type == "pvp":
        return BattlePVPProcess(red_units, red_best_skill_no, red_player_level, blue_units, blue_best_skill_no, blue_player_level)
    elif battle_type == "pve":
        return BattlePVEProcess(red_units, red_best_skill_no, red_player_level,  blue_groups, blue_player_level, friend_skill)

def init_unit(slot_no, eles, is_hero=True):

    unit_name = eles[1]
    unit_no = int(eles[2])
    quality = int(eles[3])
    hp = float(eles[4])
    atk = float(eles[5])
    physical_def = float(eles[6])
    magic_def = float(eles[7])
    hit = float(eles[8])
    dodge = float(eles[9])
    cri = float(eles[10])
    cri_coeff = float(eles[11])
    cri_def_coeff = float(eles[12])
    block = float(eles[13])
    ductility = float(eles[14])
    level = int(eles[15])
    break_level = int(eles[16])
    #init_mp = int(eles[17])

    break_skill_buff_ids = []
    if is_hero:
        hero_break_skill_buff_ids(unit_no, break_level)

    unit =  do_assemble(unit_no, quality, break_skill_buff_ids, hp, atk, physical_def, magic_def, hit, dodge, cri,
                cri_coeff, cri_def_coeff, block, ductility, slot_no, level, break_level, is_hero=True, is_break_hero=False, unit_name=unit_name)
    return unit


def hero_break_skill_buff_ids(hero_no, break_level):
        hero_break_skill_buff_ids = []
        hero_info = game_configs.hero_config.get(hero_no)

        for i in range(break_level):
            skill_id = hero_info.get("break"+str(break_level))
            skill_info = game_configs.skill_config.get(skill_id, None)
            if skill_info:
                hero_break_skill_buff_ids.extend(skill_info.get("group"))
        return hero_break_skill_buff_ids

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
    for k, v in game_configs.language_config.items():
        if v.cn == stage_name:
            stage_name_id = k
            break
    if not stage_name_id:
        print "关卡:%s 不存在！" % stage_name
        return 0

    stage_info = None

    if stage_type_id in [1,2,3]:
        for k, v in game_configs.stage_config.items():
            if v.name == stage_name_id and v.type == stage_type_id:
                stage_info = v
                break

    if stage_type_id in [5,6,7]:
        for k, v in game_configs.special_stage_config.items():
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
        monster_group_info = game_configs.monster_group_config.get(monster_group_id)
        blue_units = {}

        for j in [1,2,3,4,5,6]:
            monster_id = monster_group_info.get("pos%d" % j)
            if not monster_id: continue
            monster_info = game_configs.monster_config.get(monster_id)
            unit = BattleUnit()
            eles = [j, "怪物"+str(j), monster_id, 0, monster_info.hp, monster_info.atk, monster_info.physicalDef, monster_info.magicDef, monster_info.hit,
                     monster_info.dodge, monster_info.cri, monster_info.cri_coeff, monster_info.cri_ded_coeff, monster_info.block, monster_info.ductility,
                    monster_info.monsterLv, 0, 0]
            init_unit(j, eles, is_hero=False)
            blue_units[j] = unit
        blue_groups.append(blue_units)

    return blue_groups

if __name__ == '__main__':

    battle_type = 'pvp'
    if len(sys.argv) > 1:
        battle_type = sys.argv[1]
    process = parse_input(battle_type)
    process.process()



