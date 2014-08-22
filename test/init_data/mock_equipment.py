# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from app.game.core.PlayersManager import PlayersManager


def init_equipment(player):
    equipment_obj = Equipment('0001', '', 100001)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment('0002', '', 100002)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()

    equipment_obj = Equipment('0003', '', 100003)
    player.equipment_component.add_exist_equipment(equipment_obj)
    equipment_obj.attribute.strengthen_lv = 2
    equipment_obj.attribute.awakening_lv = 2
    equipment_obj.save_data()
