# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:37.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.redis_mode import tb_character_hero_chip
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.hero_chip import get_hero_chips
from app.proto_file.hero_chip_pb2 import GetHeroChipsResponse


class HeroChipTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_init_data(self):
        data = tb_character_hero_chip.getObj(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        num = data.get('hero_chips').get(1000112)
        self.assertEqual(num, 300, "hero_chip num error!%d_%d" % (num, 300))

    def test_save_data(self):
        hero_chip = self.player.hero_chip_component.get_chip(1000112)
        hero_chip.num = 1000
        self.player.hero_chip_component.save_data()
        data = tb_character_hero_chip.getObj(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        num = data.get('hero_chips').get(1000112)
        self.assertEqual(num, 1000, "hero_chip num error!%d_%d" % (num, 1000))

    def test_get_hero_chips(self):
        response_str = get_hero_chips(1)
        response = GetHeroChipsResponse()
        response.ParseFromString(response_str)

        lst = [x for x in response.hero_chips]
        self.assertEqual(len(lst), 2, "%d_%d" % (len(lst), 2))
