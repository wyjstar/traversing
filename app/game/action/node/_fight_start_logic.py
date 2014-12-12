#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
重用开始战斗相关代码。
"""
from app.game.action.node.stage import assemble
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

    process = BattlePVPProcess(red_units, red_best_skill, player.level.level, blue_units,
                                blue_best_skill, blue_player_level)
    fight_result = process.process()
    return fight_result


def save_line_up_order(line_up, player):
    """docstring for save_line_up_order"""
    line_up = {}  # {hero_id:pos}
    for line in line_up:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    player.line_up_component.line_up_order = line_up
    player.line_up_component.save_data()


def pvp_assemble_response(red_units, blue_units, red_skill, red_skill_level, blue_skill, blue_skill_level, response):
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
    response.red_skill = red_skill
    response.red_skill_level = red_skill_level
    response.blue_skill = blue_skill
    response.blue_skill_level = blue_skill_level


def pve_process(stage_id, stage_type, line_up, best_skill_id, fid, player):
    """docstring for pve_process
    line_up: line up order
    best_skill_id: unpar
    fid: friend id.
    """
    line_up = {}  # {hero_id:pos}
    for line in line_up:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    stage = get_stage_by_stage_type(stage_type, stage_id, player)
    stage_info = fight_start(stage, line_up, best_skill_id, fid, player)
    return stage_info


def fight_start(stage, line_up, unparalleled, fid, player):
    """开始战斗
    """
    # 校验信息：是否开启，是否达到次数上限等
    res = stage.check()
    if not res.get('result'):
        return res

    # 保存阵容
    player.line_up_component.line_up_order = line_up
    player.line_up_component.save_data()

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

def pve_assemble_response(player, red_units, blue_units, red_skill, red_skill_level, blue_skill, f_unit, response):
    """docstring for pve_assemble_response"""
    for slot_no, red_unit in red_units.items():
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)

    for blue_group in blue_units:
        blue_group_add = response.blue.add()
        for slot_no, blue_unit in blue_group.items():
            if not blue_unit:
                continue
            blue_add = blue_group_add.group.add()
            assemble(blue_add, blue_unit)

    if blue_skill:
        response.monster_unpar = blue_skill

    response.hero_unpar = red_skill
    if red_skill in player.line_up_component.unpars:
        unpar_level = player.line_up_component.unpars[red_skill]
        response.hero_unpar_level = unpar_level

    if f_unit:
        friend = response.friend
        assemble(friend, f_unit)
    logger.debug('进入关卡返回数据:%s', response)

