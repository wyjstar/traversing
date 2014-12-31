# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:30.
"""
from test.unittest.init_data.mock_heros import init_hero
from test.unittest.init_data.mock_hero_chips import init_hero_chip
from test.unittest.init_data.mock_equipment import init_equipment
from test.unittest.init_data.mock_equipment_chip import init_equipment_chip
from test.unittest.init_data.mock_item import init_item
#from test.init_data.mock_player import init_player
from test.unittest.init_data.mock_line_up import init_line_up
from test.unittest.init_data.mock_runt import init_runt
from test.unittest.init_data.mock_player import init_player
from app.game.core.character.PlayerCharacter import PlayerCharacter

def init():
    """reinit all data , every test case """

    player = PlayerCharacter(1)
    init_player(player)
    init_hero(player)
    init_hero_chip(player)
    init_equipment(player)
    init_equipment_chip(player)
    init_item(player)
    init_line_up(player)
    init_runt(player)
    return player


class MockPlayerCharacter(PlayerCharacter):
    def __init__(self):
        """docstring for __init__fname"""
        super(MockPlayerCharacter, self).__init__()

