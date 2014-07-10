# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午5:06.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest


class EquipmentTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_add_equipment(self):
        pass

