# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:37.
"""
from app.game.core.equipment.equipment import Equipment
from app.game.core.PlayersManager import PlayersManager



def init_equipment():
    equipment1 = Equipment()

    player = PlayersManager().get_player_by_id(1)
    player.equipment_component.add_equipment(equipment1)