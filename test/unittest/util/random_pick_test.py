# -*- coding:utf-8 -*-
"""
created by server on 14-7-16上午11:07.
"""

from shared.utils.random_pick import *
import unittest


class RandomPick(unittest.TestCase):
    """随机筛选"""
    def setUp(self):
        self.items_1 = {1: 5, 2: 2, 3: 2}
        self.items_2 = {1: 1}

    def test_random_pick(self):
        item_id = random_pick_with_weight(self.items_2)
        self.assertEqual(item_id, 1)

        for i in range(10):
            print random_pick_with_weight(self.items_1)

    def test_random_multi_pick(self):
        print random_multi_pick(self.items_1, 100)

    def test_random_multi_pick_without_repeat(self):
        print random_multi_pick_without_repeat(self.items_1, 100)