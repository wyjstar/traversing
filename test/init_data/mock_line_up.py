# -*- coding:utf-8 -*-
"""
created by server on 14-8-8上午10:46.
"""
from app.game.core.PlayersManager import PlayersManager


def init_line_up(player):

    equipments = player.equipment_component.equipments_obj

    slot = player.line_up_component.line_up_slots[1]
    slot.activation = 1

    slot.hero_slot.hero_no = 10001
    slot.hero_slot.activation = True

    slot.equipment_slots[1].equipment_id = '0001'
    slot.equipment_slots[1].activation = True
    slot.equipment_slots[2].equipment_id = '0002'
    slot.equipment_slots[2].activation = True

    slot = player.line_up_component.line_up_slots[2]
    slot.activation = True

    slot.hero_slot.hero_no = 10002
    slot.hero_slot.activation = True

    slot.equipment_slots[1].equipment_id = '0003'
    slot.equipment_slots[1].activation = True

    player.line_up_component.save_data()