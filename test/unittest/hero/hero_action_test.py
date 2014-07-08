# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

from test.unittest.init_test_data import init
init()
import unittest
from test.unittest.init_data.mock_heros import player
from app.game.action.node.hero import *
from app.proto_file.hero_response_pb2 import *
from app.game.service.gatenoteservice import remoteservice


class HeroActionTest(unittest.TestCase):

    def setUp(self):
        pass

    def get_hero_list_101_test(self):
        str_response = remoteservice.callTarget(101, 1)
        response = HeroListResponse()
        response.ParseFromString(str_response)
        hero_list_len = len(response.hero_list)
        self.assertEqual(hero_list_len, 3, "return hero len error!")
        self.assertEqual(response.hero_list[0].hero_no, 10001, "first hero no error!")
        self.assertEqual(response.hero_list[hero_list_len-1].hero_no, 10003, "last hero no error!")

    def hero_sacrifice_test(self):
        hero_no_list = [10001, 10002]
        heros = player.hero_component.get_heros_by_nos(hero_no_list)

        total_hero_soul, exp_item_no, exp_item_num = hero_sacrifice(heros)
        self.assertEqual(total_hero_soul, 300, "total hero soul error!")
        self.assertEqual(exp_item_no, 1000103, "exp_item_no error!")
        self.assertEqual(exp_item_num, 1, "exp_item_num error!")

    def hero_upgrade_102_test(self):
        request = HeroUpgradeRequest()
        request.hero_no_list.append(10001)
        request.exp_list.append(2000)

        str_response = remoteservice.callTarget(102, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = player.hero_component.get_hero_by_no(10001)

        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.exp, 901, "hero exp error!%d_%d" % (hero.exp, 901))
        self.assertEqual(hero.level, 12, "hero level error!%d_%d" % (hero.level, 12))

    def hero_upgrade_with_item_103_test(self):
        request = HeroUpgradeWithItemRequest()
        request.hero_no = 10001
        request.exp_item_no = 1000104
        request.exp_item_num = 2

        str_response = remoteservice.callTarget(103, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = player.hero_component.get_hero_by_no(10001)
        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.exp, 901, "hero exp error!%d_%d" % (hero.exp, 901))
        self.assertEqual(hero.level, 12, "hero level error!%d_%d" % (hero.level, 12))

    def hero_break_104_test(self):
        request = HeroBreakRequest()
        request.hero_no = 10001
        str_response = remoteservice.callTarget(104, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = player.hero_component.get_hero_by_no(10001)
        self.assertEqual(response.result, True, "return result error!")
        self.assertEqual(hero.break_level, 1, "hero breaklevel error!%d_%d" % (hero.break_level, 1))
        self.assertEqual(player.finance.coin, 29000, "hero coin error!%d_%d" % (player.finance.coin, 3000))

        hero_chip = player.hero_chip_component.get_chip(1000112)
        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))

        item = player.item_package.get_item(1000111)
        print 'item', item.num
        self.assertEqual(item.num, 0, "item error!%d_%d" % (item.num, 0))

    def hero_compose_106_test(self):
        request = HeroComposeRequest()
        request.hero_chip_no = 1000114
        hero_chip = player.hero_chip_component.get_chip(1000114)

        str_response = remoteservice.callTarget(106, 1, request.SerializeToString())
        response = CommonResponse()
        response.ParseFromString(str_response)

        hero = player.hero_component.get_hero_by_no(10004)
        self.assertEqual(response.result, True, "return result error!")
        self.assertFalse(hero == None, "compose hero error!")

        self.assertEqual(hero_chip.num, 280, "hero_chip error!%d_%d" % (hero_chip.num, 280))






