# coding:utf8

from lupa import LuaRuntime
from shared.utils.const import const
from random import randint
lua = LuaRuntime()
lua.require("app/battle/src/test_main")

#TYPE_GUIDE = 0              --演示关卡
#TYPE_STAGE_NORMAL = 1       -- 普通关卡（剧情）， stage_config
#TYPE_STAGE_ELITE = 2        -- 精英关卡， special_stage_config
#TYPE_STAGE_ACTIVITY = 3     -- 活动关卡， special_stage_config
#TYPE_TRAVEL         = 4     --travel

#TYPE_PVP            = 6     --pvp

#TYPE_WORLD_BOSS     = 7     --世界boss

#TYPE_MINE_MONSTER           = 8       -- 攻占也怪
#TYPE_MINE_OTHERUSER         = 9       -- 攻占其他玩家

#func = lua.eval('''function() return start(); end''')
#print(func())

pvp_func = lua.eval('''function(fightData, fightType, level) setData(fightData, fightType, level); return pvp_start(); end''')
pve_func = lua.eval('''function(fightData, fightType, steps, level) setData(fightData, fightType, level); return pve_start(steps); end''')

def construct_battle_unit(unit):
    # 构造战斗单元
    if not unit:
        return None
    return lua.table(
        no = unit.unit_no,
        quality = unit.quality,

        hp = unit.hp,
        hp_max = unit.hp_max,
        atk = unit.atk,
        physical_def = unit.physical_def,
        magic_def = unit.magic_def,
        hit = unit.hit,
        dodge = unit.dodge,
        cri = unit.cri,
        cri_coeff = unit.cri_coeff,
        cri_ded_coeff = unit.cri_ded_coeff,
        block = unit.block,
        ductility = unit.ductility,

        level = unit.level,
        break_level = unit.break_level,

        is_boss = unit.is_boss,
        #break_skills = unit.break_skills,
        position = unit.position,

        is_break = unit.is_break,
        is_awake = unit.is_awake,
        origin_no = unit.origin_no
    )

def pvp_start(red_units, blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, seed1, seed2, level):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for unit in blue_units.values():
        blue.append(construct_battle_unit(unit))

    fight_data = lua.table(
        red = lua.table_from(red),
        blue = lua.table_from(blue),
        red_skill = red_skill,
        red_skill_level = red_skill_level,
        blue_skill = blue_skill,
        blue_skill_level = blue_skill_level,
        fight_result = False,
        seed1 = seed1,
        seed2 = seed2
    )
    fight_type = const.BATTLE_PVP
    res = pvp_func(fight_data, fight_type, level)
    print("pvp_start=====:", res)
    if int(res[0]) == 1:
        return True
    return False

def pve_start(red_units, blue_groups, red_skill, red_skill_level, blue_skill, blue_skill_level, f_unit, seed1, seed2, step_infos, level):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for units in blue_groups:
        temp = []
        for unit in units.values():
            temp.append(construct_battle_unit(unit))
        blue.append(lua.table(group=lua.table_from(temp)))

    temp = {}
    for step in step_infos:
        temp[step.step_id] = step.step_type
    print("pve_start steps %s" % temp)
    steps = lua.table_from(temp)

    fight_data = lua.table(
        red = lua.table_from(red),
        blue = lua.table_from(blue),
        hero_unpar = red_skill,
        hero_unpar_level = red_skill_level,
        monster_unpar = blue_skill,
        #blue_skill_level = blue_skill_level,
        friend = construct_battle_unit(f_unit),
        fight_result = False,
        seed1 = seed1,
        seed2 = seed2
    )
    fight_type = const.BATTLE_PVE
    res = pve_func(fight_data, fight_type, steps, level)
    if int(res) == 1:
        return True
    return False

def world_boss_start(red_units,  blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, player_level, debuff_skill_no, damage_rate, seed1, seed2, level):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for unit in blue_units.values():
        blue.append(construct_battle_unit(unit))

    fight_data = lua.table(
        red = lua.table_from(red),
        blue = lua.table_from(blue),
        red_best_skill = red_skill,
        red_best_skill_level = red_skill_level,
        blue_skill = blue_skill,
        blue_skill_level = blue_skill_level,
        seed1 = seed1,
        seed2 = seed2,
        debuff_skill_no = debuff_skill_no,
        damage_rate= damage_rate
    )
    fight_type = const.BATTLE_PVB
    res = pvp_func(fight_data, fight_type, level)
    print("world_boss_start=====:", res, level)
    if int(res[0]) == 1:
        return {"result":True, "hp_left":res[1]}
    return {"result":False, "hp_left":res[1]}

       # required CommonResponse res = 1;
	#repeated BattleUnit red = 2;         // 红方数据 自己
	#repeated BattleUnit blue = 3;    // 对方数据
	#optional int32 red_best_skill_id = 4;       // 无双
	#optional int32 red_best_skill_level = 5; // 无双
	#optional int32 blue_best_skill_id = 6;       // 无双
	#optional int32 blue_best_skill_level = 7; // 无双
	#repeated int32 awake_no = 8;        //
	#optional int32 seed1= 9;
       # optional int32 seed2= 10;
def mine_pvp_start(red_units, blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, seed1, seed2, level):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for unit in blue_units.values():
        blue.append(construct_battle_unit(unit))

    fight_data = lua.table(
        red = lua.table_from(red),
        blue = lua.table_from(blue),
        red_best_skill_id = red_skill,
        red_best_skill_level = red_skill_level,
        blue_best_skill_id = blue_skill,
        blue_best_skill_level = blue_skill_level,
        seed1 = seed1,
        seed2 = seed2
    )
    fight_type = const.BATTLE_MINE_PVP
    res = pvp_func(fight_data, fight_type, level)
    print("pvp_start=====:", res)
    if int(res[0]) == 1:
        return True
    return False

def mine_start(red_units, blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, seed1, seed2, step_infos, level):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for unit in blue_units.values():
        blue.append(construct_battle_unit(unit))
    temp = {}
    for step in step_infos:
        temp[step.step_id] = step.step_type
    print("pve_start steps %s" % temp)
    steps = lua.table_from(temp)

    fight_data = lua.table(
        red = lua.table_from(red),
        blue = lua.table_from(blue),
        red_best_skill_id = red_skill,
        red_best_skill_level = red_skill_level,
        blue_best_skill_id = blue_skill,
        blue_best_skill_level = blue_skill_level,
        seed1 = seed1,
        seed2 = seed2
    )
    fight_type = const.BATTLE_MINE_PVE
    res = pvp_func(fight_data, fight_type)
    print("pvp_start=====:", res)
    res = pve_func(fight_data, fight_type, steps, level)
    if int(res) == 1:
        return True
    return False

def get_seeds():
    seed1 = randint(1, 100)
    seed2 = randint(1, 100)
    return seed1, seed2
