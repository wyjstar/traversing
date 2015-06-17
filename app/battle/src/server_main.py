# coding:utf8

from lupa import LuaRuntime
lua = LuaRuntime()
lua.require("src/test_main")

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

func = lua.eval('''function(fightData, fightType) setData(fightData, fightType); return start(); end''')

def construct_battle_unit(unit):
    # 构造战斗单元
    return lua.table(
        no = unit.no,
        quality = unit.quality,

        hp = unit.hp,
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
        break_skills = unit.break_skills,
        position = unit.position,

        is_break = unit.is_break,
        is_awake = unit.is_awake,
        origin_no = unit.origin_no
    )

def pvp_start(red_units, blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, fight_result, seed1, seed2):
    red = []
    blue = []
    for unit in red_units.values():
        red.append(construct_battle_unit(unit))
    for unit in blue_units.values():
        blue.append(construct_battle_unit(unit))

    fight_data = lua.table(
        red = lua.table(red),
        blue = lua.table(blue),
        red_skill = red_skill,
        red_skill_level = red_skill_level,
        blue_skill = blue_skill,
        blue_skill_level = blue_skill_level,
        fight_result = fight_result,
        seed1 = seed1,
        seed2 = seed2
    )
    fight_type = 6
    return func(fight_data, fight_type)
