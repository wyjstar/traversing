# -*- coding:utf-8 -*-
"""
created by server on 14-8-8上午10:46.
"""
from app.game.core.PlayersManager import PlayersManager


def init_line_up(player):

    equipments = player.equipment_component.equipments_obj

    slot = player.line_up_component.line_up_slots[1]

    # print '###1 init line up:', slot.__dict__

    slot.activation = True

    slot.hero_slot.hero_no = 10046
    slot.hero_slot.activation = True


    # slot.equipment_slots[1].activation = True
    # slot.equipment_slots[2].activation = True
    #
    # slot = player.line_up_component.line_up_slots[2]
    # slot.activation = True
    #
    # slot.hero_slot.hero_no = 10029
    # slot.hero_slot.activation = True
    #
    # slot.equipment_slots[1].activation = True
    #
    # slot = player.line_up_component.line_up_slots[3]
    # slot.activation = True
    #
    # slot.hero_slot.hero_no = 10043
    # slot.hero_slot.activation = True
    #
    # slot.equipment_slots[1].activation = True
    # print id(player)
    player.line_up_component.save_data()