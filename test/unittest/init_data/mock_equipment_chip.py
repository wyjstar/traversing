# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午2:50.
"""

from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_character_equipment_chip


def init_equipment_chip():

    chip1 = EquipmentChip(1000112, 300)
    chip2 = EquipmentChip(1000114, 300)

    data = {'id': 1, 'chips': ''}
    tb_character_equipment_chip.new(data)

    player = PlayersManager().get_player_by_id(1)
    player.equipment_chip_component.add_chip(chip1)
    player.equipment_chip_component.add_chip(chip2)