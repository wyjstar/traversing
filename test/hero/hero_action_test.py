# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.hero.mock_redis
import test.hero.mock_config
from test.hero.mock_heros import player
from app.game.action.node.hero import hero_sacrifice
import unittest


class HeroActionTest(unittest.TestCase):

    def setUp(self):
        pass

    def test_hero_sacrifice(self):
        hero_no_list = [10001, 10002]
        heros = player.hero_list.get_heros_by_nos(hero_no_list)

        total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)
        self.assertEqual(total_hero_soul, 300, "total hero soul error!")
        self.assertEqual(exp_item_no, 1000101, "exp_item_no error!")
        self.assertEqual(exp_item_num, 2, "exp_item_num error!")



