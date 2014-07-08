# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""

from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager


if not PlayersManager().get_player_by_id(1):
    player = PlayerCharacter(1, dynamic_id=1, status=0)
    player.finance.coin = 30000
    player.finance.hero_soul = 20000

    PlayersManager().add_player(player)
