#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
重用开始战斗相关代码。
"""
from app.game.component.fight.stage_factory import get_stage_by_stage_type
from app.game.redis_mode import tb_character_lord
from gfirefly.server.logobj import logger
from app.battle.battle_unit import BattleUnit
from app.battle.battle_process import BattlePVPProcess

def pvp_process(player, line_up, red_units, blue_units, red_best_skill, blue_best_skill, blue_player_level):
    """docstring for pvp_process"""
    save_line_up_order(line_up, player)
    #player.fight_cache_component.awake_hero_units(blue_units)
    player.fight_cache_component.awake_hero_units(red_units)
    if not blue_units:
        return True

    process = BattlePVPProcess(red_units, red_best_skill, player.level.level, blue_units,
                                blue_best_skill, blue_player_level)
    fight_result = process.process()
    return fight_result


def save_line_up_order(line_up, player):
    """docstring for save_line_up_order"""
    line_up_info = {}  # {hero_id:pos}
    for line in line_up:
        if not line.hero_id:
            continue
        line_up_info[line.hero_id] = line.pos

    player.line_up_component.line_up_order = line_up_info
    player.line_up_component.save_data()


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
    save_line_up_order(line_up, player)

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
    red_units, blue_units, drop_num, monster_unpara = fight_cache_component.fighting_start()

    # 好友
    lord_data = tb_character_lord.getObjData(fid)
    f_unit = None
    if lord_data:
        info = lord_data.get('attr_info').get('info')
        f_unit = BattleUnit.loads(info)
    else:
        logger.info('can not find friend id :%d' % fid)

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

    #if blue_skill:
        #response.monster_unpar = blue_skill

    #response.hero_unpar = red_skill
    #if red_skill in player.line_up_component.unpars:
        #unpar_level = player.line_up_component.unpars[red_skill]
        #response.hero_unpar_level = unpar_level

def pve_assemble_friend(f_unit, response):
    if f_unit:
        friend = response.friend
        assemble(friend, f_unit)
    logger.debug('进入关卡返回数据:%s', response)

def assemble(unit_add, unit):
    unit_add.no = unit.unit_no
    unit_add.quality = unit.quality

    for skill_no in unit.skill.break_skill_ids:
        unit_add.break_skills.append(skill_no)

    unit_add.hp = unit.hp
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

    unit_add.position = unit.slot_no
    unit_add.is_boss = unit.is_boss

    unit_add.is_awake = unit.is_awake
    unit_add.origin_no = unit.origin_no
    unit_add.is_break = unit.is_break
    unit_add.origin_no = unit.origin_no
