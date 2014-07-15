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

    def test_random_pick(self):
        small_bag = SmallBag(1002)
        for i in range(100):
            drop_item = small_bag.random_pick()
            self.assertTrue(drop_item.drop_id in [1, 2])
            print drop_item.drop_id, drop_item.item_no, drop_item.item_type, drop_item.item_num

    def test_random_multi_pick(self):
        small_bag = SmallBag(1002)
        drop_items = small_bag.random_multi_pick(100)
        self.assertTrue(len(drop_items) == 100)
        for drop_item in drop_items:
            self.assertTrue(drop_item.drop_id in [1, 2])
            print drop_item.drop_id, drop_item.item_no, drop_item.item_type, drop_item.item_num

    def test_random_multi_pick_without_repeat(self):
        small_bag = SmallBag(1002)
        drop_items = small_bag.random_multi_pick_without_repeat(100)
        self.assertTrue(len(drop_items) == 2, "%d_%d" % (len(drop_items), 2))
        for drop_item in drop_items:
            self.assertTrue(drop_item.drop_id in [1, 2])
            print drop_item.drop_id, drop_item.item_no, drop_item.item_type, drop_item.item_num

    def test_get_drop_items(self):
        big_bag = BigBag(10001)
        drop_items = big_bag.get_drop_items()
        self.assertEqual(len(drop_items), 3, "%d_%d" % (len(drop_items), 3))