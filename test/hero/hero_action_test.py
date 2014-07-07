# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.hero.mock_config
import test.hero.mock_redis
from test.hero.mock_heros import player
from app.game.action.node.hero import *
from app.proto_file.hero_response_pb2 import *
import unittest
from gfirefly.server.globalobject import GlobalObject


class HeroActionTest(unittest.TestCase):

    def setUp(self):
        #GlobalObject().remote['gate'] =
        pass

    def get_hero_list_101_test(self):
        str_response = get_hero_list_101(1)
        response = HeroListResponse()
        response.ParseFromString(str_response)
        hero_list_len = len(response.hero_list)
        self.assertEqual(hero_list_len, 3, "return hero len error!")
        self.assertEqual(response.hero_list[0].hero_no, 10001, "first hero no error!")
        self.assertEqual(response.hero_list[hero_list_len-1].hero_no, 10003, "last hero no error!")

    def test_hero_sacrifice(self):
        hero_no_list = [10001, 10002]
        heros = player.hero_list.get_heros_by_nos(hero_no_list)

        total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)
        self.assertEqual(total_hero_soul, 300, "total hero soul error!")
        self.assertEqual(exp_item_no, 1000103, "exp_item_no error!")
        self.assertEqual(exp_item_num, 1, "exp_item_num error!")

    def test_hero_upgrade(self):
        pass

    def test_hero_break(self):
        pass

    def test_hero_compose(self):
        pass



