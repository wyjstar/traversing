# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""

from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_character_info


def init_player(player):
    player.finance.coin = 30000
    player.finance.hero_soul = 20000
    player.finance.gold = 10000
    player.finance.save_data()

    player.level.level = 200
    player.level.exp = 100
    player.line_up_component.update_slot_activation()
    player.last_pick_time.fine_hero = 0
    player.last_pick_time.excellent_hero = 0
    player.last_pick_time.fine_equipment = 0
    player.last_pick_time.excellent_equipment = 0
    player.last_pick_time.save_data()
    player.save_data()
