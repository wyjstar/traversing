# -*- coding:utf-8 -*-
"""
created by server on 14-8-8上午10:46.
"""
from app.game.core.PlayersManager import PlayersManager


def init_line_up():
    player = PlayersManager().get_player_by_id(1)

    equipments = player.equipment_component.equipments_obj
    equipment_ids = equipments.keys()

    slot = player.line_up_component.line_up_slots[1]
    slot.activation = True
    slot.hero_no = 10001
    slot.equipment_ids[1] = equipment_ids[0]
    slot.equipment_ids[2] = equipment_ids[1]

    slot = player.line_up_component.line_up_slots[2]
    slot.activation = True
    slot.hero_no = 10002
    slot.equipment_ids[1] = equipment_ids[1]
    slot.equipment_ids[3] = equipment_ids[2]

    slot = player.line_up_component.line_up_slots[3]
    slot.activation = True
    slot.hero_no = 10003
    slot.equipment_ids[1] = equipment_ids[2]
    slot.equipment_ids[4] = equipment_ids[3]

    slot = player.line_up_component.line_up_slots[4]
    slot.activation = True
    slot.hero_no = 10004
    slot.equipment_ids[1] = equipment_ids[3]
    slot.equipment_ids[5] = equipment_ids[4]

    slot = player.line_up_component.line_up_slots[5]
    slot.activation = False

    slot = player.line_up_component.line_up_slots[6]
    slot.activation = False