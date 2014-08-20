# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from app.game.core.PlayersManager import PlayersManager


def init_equipment(player):
    equipment = player.equipment_component.add_equipment(100001)
    equipment.attribute.strengthen_lv = 1
    equipment.attribute.awakening_lv = 1
    equipment.save_data()

    equipment = player.equipment_component.add_equipment(100002)
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()

    equipment = player.equipment_component.add_equipment(100003)
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()
