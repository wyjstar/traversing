# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午1:47.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.logic.soul_shop import *


class SoulShopTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_all_shop_items(self):
        items = get_all_shop_items()
        self.assertEqual(items[1001], 50, "%d_%d" % (items[1001], 50))
        self.assertEqual(items[1002], 50, "%d_%d" % (items[1002], 50))

    def test_get_shop_item_ids(self):
        ids = get_shop_item_ids()
        self.assertEqual(len(ids), 2, "%d_%d" % (len(ids), 2))

