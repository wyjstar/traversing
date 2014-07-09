# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""

from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager


def init_player():
    PlayersManager().drop_player_by_id(1)
    player = PlayerCharacter(1, dynamic_id=1, status=1)
    player.finance.coin = 30000
    player.finance.hero_soul = 20000
    player.finance.gold = 1000
    player.finance.save_data()

    PlayersManager().add_player(player)
