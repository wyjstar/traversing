# -*- coding:utf-8 -*-
"""
created by server on 14-8-20下午6:02.
"""
#import test.unittest.init_data.init_connection
from test.init_data.mock_heros import init_hero
from test.init_data.mock_hero_chips import init_hero_chip
from test.init_data.mock_equipment import init_equipment
from test.init_data.mock_equipment_chip import init_equipment_chip
from test.init_data.mock_item import init_item
from test.init_data.mock_line_up import init_line_up
from test.init_data.mock_runt import init_runt
from test.init_data.mock_guild import init_guild
from test.init_data.mock_travel_item import init_travel_item
from test.init_data.mock_player import init_player


def init(player):
    init_player(player)
    init_hero(player)
    init_hero_chip(player)
    init_equipment(player)
    init_equipment_chip(player)
    init_item(player)
    init_line_up(player)
    init_runt(player)
    # init_guild(player)
    init_travel_item(player)
