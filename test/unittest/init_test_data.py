# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:30.
"""
from test.unittest.init_data.mock_heros import init_hero
from test.unittest.init_data.mock_hero_chips import init_hero_chip
from test.unittest.init_data.mock_equipment import init_equipment
from test.unittest.init_data.mock_equipment_chip import init_equipment_chip
from test.unittest.init_data.mock_item import init_item
from test.unittest.init_data.mock_line_up import init_line_up
from test.unittest.init_data.mock_runt import init_runt
from test.unittest.init_data.mock_player import init_player
from test.unittest.init_data.mock_travel_item import init_travel_item
from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager

def init():
    """reinit all data , every test case """

    player = PlayerCharacter(1, dynamic_id=1)
    PlayersManager().add_player(player)
    init_player(player)
    init_hero(player)
    init_hero_chip(player)
    init_equipment(player)
    init_equipment_chip(player)
    init_item(player)
    init_line_up(player)
    init_runt(player)
    init_travel_item(player)
    return player
