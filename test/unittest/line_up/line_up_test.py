# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午6:12.
"""

import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.redis_mode import tb_character_line_up


class LineUpTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_add_hero(self):
        line_up_component = self.player.line_up_component
        line_up_component.add_hero(10001)
        line_up_item = line_up_component.get_line_up_item(1)
        self.assertEqual(line_up_item.hero_no, 10001, "%d_%d" % (line_up_item.hero_no, 10001))
        self.assertEqual(len(line_up_component.line_up_order), 1, "%d_%d" % (len(line_up_component.line_up_order), 1))
        self.assertEqual(line_up_component.line_up_order[0], 1, "%d_%d" % (line_up_component.line_up_order[0], 1))