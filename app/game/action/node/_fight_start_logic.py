#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
重用开始战斗相关代码。
"""
from app.game.action.node.stage import assemble


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





