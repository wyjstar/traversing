# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""

from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager

player = PlayerCharacter('playerid1', dynamic_id=1, status=0)

PlayersManager().add_player(player)
