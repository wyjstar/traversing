# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午2:19.
"""

import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.core.drop_bag import BigBag, SmallBag


class DropBagTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_drop_items(self):
        big_bag = BigBag(10001)
        drop_items = big_bag.get_drop_items()
        self.assertEqual(len(drop_items), 3, "%d_%d" % (len(drop_items), 3))