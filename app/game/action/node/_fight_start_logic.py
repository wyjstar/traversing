#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
重用开始战斗相关代码。
"""
from app.game.component.fight.stage_factory import get_stage_by_stage_type
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from app.battle.battle_unit import BattleUnit
#from app.battle.battle_process import BattlePVPProcess
from app.battle.server_process import pvp_start, pve_start, mine_start, mine_pvp_start, guild_pvp_start
from random import randint
from shared.utils.const import const
from shared.common_logic.feature_open import is_not_open, FO_FRIEND_SUPPORT


def pvp_process(player, line_up, red_units, blue_units, seed1, seed2, fight_type):
    """docstring for pvp_process"""
    #save_line_up_order(line_up, player, current_unpar)
    #player.fight_cache_component.awake_hero_units(blue_units)
    #player.fight_cache_component.awake_hero_units(red_units)
    if not blue_units:
        return True

    #unpar_type = player.line_up_component.unpar_type
    #unpar_other_id = player.line_up_component.unpar_other_id
    #red_unpar_data = dict(unpar_type=unpar_type, unpar_other_id=unpar_other_id)

    if fight_type == const.BATTLE_PVP:
        res = pvp_start(red_units, blue_units, {}, {},
                                seed1, seed2, player.base_info.level)
    elif fight_type == const.BATTLE_MINE_PVP:
        res = mine_pvp_start(red_units, blue_units, {}, {},
                                seed1, seed2, player.base_info.level)
    elif fight_type == const.BATTLE_GUILD:
        res = guild_pvp_start(red_units, blue_units, seed1, seed2)

    logger.debug("pvp_process: %s" % res)
    #fight_result = process.process()
    return res

def pve_process_check(player, fight_result, steps, fight_type):
    """pve 校验"""
    stage_info = player.fight_cache_component.stage_info
    red_units = stage_info.get('red_units')
    blue_groups = stage_info.get('blue_units')
    #drop_num = stage_info.get('drop_num')
    monster_unpara = stage_info.get('monster_unpara')
    f_unit = stage_info.get('f_unit')
    logger.debug("pve_process_check %s", red_units)
    logger.debug("pve_process_check %s", blue_groups)

    seed1 = player.fight_cache_component.seed1
    seed2 = player.fight_cache_component.seed2
    red_unpar_data = player.line_up_component.get_red_unpar_data()
    blue_unpar_data = dict(blue_skill=monster_unpara, blue_skill_level=1)

    if fight_type == const.BATTLE_PVE:
        res = pve_start(red_units, blue_groups, red_unpar_data,
                            blue_unpar_data, f_unit, seed1, seed2, steps, player.base_info.level)
    elif fight_type == const.BATTLE_MINE_PVE:
        blue_units = blue_groups[0]
        res = mine_start(red_units, blue_units, red_unpar_data,
                            blue_unpar_data, seed1, seed2, steps, player.base_info.level)
    logger.debug("pve_start %s %s" % (res, fight_result))
    return res[0] == fight_result, res[1], res[2], res[3], res[4]

def save_line_up_order(line_up, player, current_unpar, stage_id=0):
    """docstring for save_line_up_order"""
    line_up_info = []  # {hero_id:pos}
    for line in line_up:
        line_up_info.append(line)
    if len(line_up_info) != 6:
        logger.error("line up order error %s !" % len(line_up_info))
        return
    logger.debug("line_up %s, current_unpar%s"% (line_up, current_unpar))
    player.fight_cache_component.stage_id = stage_id
    player.line_up_component.line_up_order = line_up_info
    player.line_up_component.current_unpar = current_unpar
    player.line_up_component.save_data(["line_up_order", "current_unpar"])


def pvp_assemble_units(red_units, blue_units, response):
    """assemble pvp response"""
    for slot_no, red_unit in red_units.items():
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)
    for slot_no, blue_unit in blue_units.items():
        if not blue_unit:
            continue
        blue_add = response.blue.add()
        assemble(blue_add, blue_unit)


def pve_process(stage_id, stage_type, line_up, fid, player):
    """docstring for pve_process
    line_up: line up order
    best_skill_id: unpar
    fid: friend id.
    """
    player.fight_cache_component.stage_id = stage_id

    stage = get_stage_by_stage_type(stage_type, stage_id, player)

    stage_info = fight_start(stage, fid, player)
    return stage_info


def fight_start(stage, fid, player):
    """开始战斗
    """
    # 校验信息：是否开启，是否达到次数上限等
    res = stage.check()
    if not res.get('result'):
        return res

    fight_cache_component = player.fight_cache_component
    fight_cache_component.stage_id = stage.stage_id
    fight_cache_component.stage = stage
    red_units, blue_units, drop_num, monster_unpara = fight_cache_component.fighting_start()

    # 好友
    char_obj = tb_character_info.getObj(fid)
    lord_data = char_obj.hget('lord_attr_info')
    f_unit = None
    if lord_data and not is_not_open(player, FO_FRIEND_SUPPORT):
        info = lord_data.get('info')
        f_unit = BattleUnit.loads(info)
    else:
        logger.debug('can not find friend id :%d' % fid)

    return dict(result=True,
                red_units=red_units,
                blue_units=blue_units,
                drop_num=drop_num,
                monster_unpara=monster_unpara,
                f_unit=f_unit,
                result_no=0)


def pve_assemble_units(red_units, blue_groups, response):
    """docstring for pve_assemble_response"""
    for slot_no, red_unit in red_units.items():
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)

    for blue_group in blue_groups:
        blue_group_add = response.blue.add()
        for slot_no, blue_unit in blue_group.items():
            if not blue_unit:
                continue
            blue_add = blue_group_add.group.add()
            assemble(blue_add, blue_unit)

    # if blue_skill:
    #     response.monster_unpar = blue_skill

    # response.hero_unpar = red_skill
    # if red_skill in player.line_up_component.unpars:
    #     unpar_level = player.line_up_component.unpars[red_skill]
    #     response.hero_unpar_level = unpar_level


def pve_assemble_friend(f_unit, response):
    if f_unit:
        friend = response.friend
        assemble(friend, f_unit)
    # logger.debug('进入关卡返回数据:%s', response)


def assemble(unit_add, unit):
    unit_add.no = unit.unit_no
    unit_add.quality = unit.quality

    for skill_no in unit.skill.break_skill_ids:
        unit_add.break_skills.append(skill_no)

    unit_add.hp = unit.hp
    unit_add.hp_max = unit.hp_max
    unit_add.atk = unit.atk
    unit_add.physical_def = unit.physical_def
    unit_add.magic_def = unit.magic_def
    unit_add.hit = unit.hit
    unit_add.dodge = unit.dodge
    unit_add.cri = unit.cri
    unit_add.cri_coeff = unit.cri_coeff
    unit_add.cri_ded_coeff = unit.cri_ded_coeff
    unit_add.block = unit.block

    unit_add.level = unit.level
    unit_add.break_level = unit.break_level

    unit_add.position = unit.position
    unit_add.is_boss = unit.is_boss

    unit_add.is_awake = unit.is_awake
    unit_add.origin_no = unit.origin_no
    unit_add.is_break = unit.is_break
    unit_add.origin_no = unit.origin_no
    unit_add.awake_level = unit.awake_level
    unit_add.power = int(unit.power)

def get_seeds():
    seed1 = randint(1, 100)
    seed2 = randint(1, 100)
    return seed1, seed2

