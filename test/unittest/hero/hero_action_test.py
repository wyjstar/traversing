# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.action.node.hero import *
from app.proto_file.hero_response_pb2 import *
from app.game.service.gatenoteservice import remoteservice


class HeroActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_hero_list_101(self):
        str_response = remoteservice.callTarget(101, 1)
        response = HeroListResponse()
        response.ParseFromString(str_response)
        hero_list_len = len(response.hero_list)
        self.assertEqual(hero_list_len, 3, "return hero len error!%d" % hero_list_len)
        self.assertEqual(response.hero_list[0].hero_no, 10001, "first hero no error!")
        self.assertEqual(response.hero_list[hero_list_len-1].hero_no, 10003, "last hero no error!")

    def test_hero_sacrifice(self):
        hero_no_list = [10001, 10002]
        heros = self.player.hero_component.get_heros_by_nos(hero_no_list)

        total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)
        self.assertEqual(total_hero_soul, 300, "total hero soul error!")
        self.assertEqual(exp_item_no, 1000103, "exp_item_no error!")
        self.assertEqual(exp_item_num, 1, "exp_item_num error!")

    def test_hero_upgrade_102(self):
        request = HeroUpgradeRequest()
        request.hero_no_list.append(10001)
        request.exp_list.append(2000)

        str_response = remoteservice.callTarget(102, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero_by_no(10001)

        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.exp, 901, "hero exp error!%d_%d" % (hero.exp, 901))
        self.assertEqual(hero.level, 12, "hero level error!%d_%d" % (hero.level, 12))

    def test_hero_upgrade_with_item_103(self):
        request = HeroUpgradeWithItemRequest()
        request.hero_no = 10001
        request.exp_item_no = 1000104
        request.exp_item_num = 2

        str_response = remoteservice.callTarget(103, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero_by_no(10001)
        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.exp, 901, "hero exp error!%d_%d" % (hero.exp, 901))
        self.assertEqual(hero.level, 12, "hero level error!%d_%d" % (hero.level, 12))

    def test_hero_break_104(self):
        request = HeroBreakRequest()
        request.hero_no = 10001
        str_response = remoteservice.callTarget(104, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero_by_no(10001)
        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.break_level, 1, "hero breaklevel error!%d_%d" % (hero.break_level, 1))
        self.assertEqual(self.player.finance.coin, 29000, "hero coin error!%d_%d" % (self.player.finance.coin, 3000))

        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))

        item = self.player.item_package.get_item(1000111)
        print 'item', item.num
        self.assertEqual(item.num, 0, "item error!%d_%d" % (item.num, 0))

    def test_hero_compose_106(self):
        request = HeroComposeRequest()
        request.hero_chip_no = 1000114
        hero_chip = self.player.hero_chip_component.get_chip(1000114)

        str_response = remoteservice.callTarget(106, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero_by_no(10004)
        self.assertEqual(response.result, True, "return result error!")
        self.assertFalse(hero == None, "compose hero error!")

        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))

if __name__ == '__main__':
    unittest.main()






