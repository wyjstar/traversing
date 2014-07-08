# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午8:37.
"""
import unittest
from test.unittest.init_test_data import init
init()

from test.unittest.init_data.mock_hero_chips import player
from app.game.redis_mode import tb_character_hero_chip
from app.game.component.character_hero_chip import CharacterHeroChipComponent


class HeroChipTest(unittest.TestCase):
    def setUp(self):
        pass

    def init_data_test(self):
        data = tb_character_hero_chip.getObjData(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        num = data.get('hero_chips').get(1000112)
        self.assertEqual(num, 300, "hero_chip num error!%d_%d" % (num, 300))

    def save_data_test(self):
        hero_chip = player.hero_chip_list.get_chip(1000112)
        hero_chip.num = 1000
        player.hero_chip_list.save_data()
        data = tb_character_hero_chip.getObjData(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        num = data.get('hero_chips').get(1000112)
        self.assertEqual(num, 1000, "hero_chip num error!%d_%d" % (num, 1000))





