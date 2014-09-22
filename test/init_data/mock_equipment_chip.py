# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午2:50.
"""

from app.game.core.equipment.equipment_chip import EquipmentChip
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_character_equipment_chip


def init_equipment_chip(player):

    chip1 = EquipmentChip(2100005, 16)
    chip2 = EquipmentChip(2100006, 16)

    player.equipment_chip_component.add_chip(chip1)
    player.equipment_chip_component.add_chip(chip2)