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
    slot.activation = 1

    slot.hero_slot.hero_no = 10001
    slot.hero_slot.activation = True

    slot.equipment_slots[1].equipment_id = equipment_ids[0]
    slot.equipment_slots[1].activation = True
    slot.equipment_slots[2].equipment_id = equipment_ids[1]
    slot.equipment_slots[2].activation = True

    slot = player.line_up_component.line_up_slots[2]
    slot.activation = True

    slot.hero_slot.hero_no = 10002
    slot.hero_slot.activation = True

    slot.equipment_slots[1].equipment_id = equipment_ids[1]
    slot.equipment_slots[1].activation = True
    slot.equipment_slots[3].equipment_id = equipment_ids[2]
    slot.equipment_slots[3].activation = True

    slot = player.line_up_component.line_up_slots[3]
    slot.activation = True



    player.line_up_component.save_data()