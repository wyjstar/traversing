# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午3:17.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.item_group_helper import *

class ItemGroupHelperTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_parse(self):
        data = {1: [1, 1, 1001], 2: [2, 2, 1002], 3: [3, 3, 1003]}
        item_group = parse(data)
        first = item_group[0]
        self.assertEqual(first.type_id, 1, "first item type id error!%d_%d" % (first.type_id, 1))
        self.assertEqual(first.num, 1, "first item type id error!%d_%d" % (first.num, 1))
        self.assertEqual(first.obj_id, 1001, "first item type id error!%d_%d" % (first.obj_id, 0011))

        last = item_group[len(item_group)-1]
        self.assertEqual(last.type_id, 3, "first item type id error!%d_%d" % (last.type_id, 3))
        self.assertEqual(last.num, 3, "first item type id error!%d_%d" % (last.num, 3))
        self.assertEqual(last.obj_id, 1003, "first item type id error!%d_%d" % (last.obj_id, 1003))

    def test_is_afford(self):
        consume_data = {1: [30000, 30000, 0],
                        2: [10000, 10000, 0],
                        3: [20000, 20000, 0],
                        4: [300, 300, 1000112],
                        5: [2, 2, 1000111]}

        result = is_afford(self.player, parse(consume_data))
        self.assertEqual(result.get('result'), True)

        import copy
        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[1][0] += 1
        consume_data_copy[1][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)
        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[2][0] += 1
        consume_data_copy[2][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[3][0] += 1
        consume_data_copy[3][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[4][0] += 1
        consume_data_copy[4][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

        consume_data_copy = copy.deepcopy(consume_data)
        consume_data_copy[5][0] += 1
        consume_data_copy[5][1] += 1
        result = is_afford(self.player, parse(consume_data_copy))
        self.assertEqual(result.get('result'), False)

    def test_consume(self):
        pass

    def test_gain(self):
        pass