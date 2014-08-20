# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.action.node.hero import *
from app.proto_file.hero_response_pb2 import *
from app.game.service.gatenoteservice import remoteservice
from app.game.core.PlayersManager import PlayersManager


class HeroActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_hero_list_101(self):
        str_response = remoteservice.callTarget(101, 1)
        response = GetHerosResponse()
        response.ParseFromString(str_response)
        hero_list_len = len(response.heros)
        self.assertEqual(hero_list_len, 6, "return hero len error!%d" % hero_list_len)
        self.assertEqual(response.heros[0].hero_no, 10001, "first hero no error!")

    def test_hero_upgrade_with_item_103(self):
        request = HeroUpgradeWithItemRequest()
        request.hero_no = 10001
        request.exp_item_no = 1000104
        request.exp_item_num = 2

        str_response = remoteservice.callTarget(103, 1, request.SerializeToString())
        response = HeroUpgradeResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero(10001)
        self.assertEqual(response.res.result, True, "return result error!")
        self.assertEqual(hero.exp, 901, "hero exp error!%d_%d" % (hero.exp, 901))
        self.assertEqual(hero.level, 12, "hero level error!%d_%d" % (hero.level, 12))
        self.assertEqual(response.exp, 901, "hero exp error!%d_%d" % (response.exp, 901))
        self.assertEqual(response.level, 12, "hero level error!%d_%d" % (response.level, 12))

    def test_hero_break_104(self):
        request = HeroBreakRequest()
        request.hero_no = 10001
        str_response = remoteservice.callTarget(104, 1, request.SerializeToString())
        response = HeroBreakResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero(10001)
        self.assertEqual(response.res.result, True, "return result error!")
        self.assertEqual(hero.break_level, 2, "hero breaklevel error!%d_%d" % (hero.break_level, 2))
        self.assertEqual(self.player.finance.coin, 29000, "hero coin error!%d_%d" % (self.player.finance.coin, 3000))

        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))

        item = self.player.item_package.get_item(1000111)
        self.assertEqual(item.num, 0, "item error!%d_%d" % (item.num, 0))
        self.assertEqual(response.break_level, 2, "%d_%d" % (response.break_level, 2))

    def test_hero_sacrifice_105(self):
        hero_no_list = [10001, 10002]
        request = HeroSacrificeRequest()
        [request.hero_nos.append(x) for x in hero_no_list]
        str_response = remoteservice.callTarget(105, 1, request.SerializeToString())
        response = HeroSacrificeResponse()
        response.ParseFromString(str_response)
        self.assertEqual(response.res.result, True)
        self.assertEqual(response.gain.finance.hero_soul, 300, "total hero soul error!%d_%d" %
                         (response.gain.finance.hero_soul, 300))
        self.assertEqual(response.gain.items[0].item_no, 1000104, "%d_%d" % (response.gain.items[0].item_no, 1000104))
        self.assertEqual(response.gain.items[0].item_num, 12,  "%d_%d" % (response.gain.items[0].item_num, 12))


    def test_hero_compose_106(self):
        request = HeroComposeRequest()
        request.hero_chip_no = 1000114
        hero_chip = self.player.hero_chip_component.get_chip(1000114)

        str_response = remoteservice.callTarget(106, 1, request.SerializeToString())
        response = HeroComposeResponse()
        response.ParseFromString(str_response)

        hero = self.player.hero_component.get_hero(10004)
        self.assertEqual(response.res.result, True, "return result error!")

        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))
        self.assertEqual(response.hero.hero_no, 10009, "%d_%d" % (response.hero.hero_no, 10009))


if __name__ == '__main__':
    unittest.main()






