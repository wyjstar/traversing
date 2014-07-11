# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from app.game.core.PlayersManager import PlayersManager


def init_equipment():
    print '#1 --------------------'
    player = PlayersManager().get_player_by_id(1)
    equipment = player.equipment_component.add_equipment(110001)
    equipment.base_info.base_name = 'e1'
    equipment.attribute.strengthen_lv = 1
    equipment.attribute.awakening_lv = 1
    equipment.save_data()

    player.equipment_component.add_equipment(110002)
    equipment.base_info.base_name = 'e2'
    equipment.attribute.strengthen_lv = 2
    equipment.attribute.awakening_lv = 2
    equipment.save_data()