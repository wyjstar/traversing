# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""
from test.unittest.init_test_data import init
from test.unittest.init_data.mock_player import player
init()

import unittest
from app.game.component.character_herolist import CharacterHeroListComponent
from app.game.core.hero import Hero


class HeroTest(unittest.TestCase):
    """test heros_component and hero"""
    def setUp(self):
        pass

    def add_hero_test(self):
        hero = Hero()
        hero.hero_no = 10011
        hero.level = 11
        hero.break_level = 2
        hero.exp = 1,
        hero.equipment_ids = []
        player.hero_list.add_hero(hero)
        length = len(player.hero_list)
        self.assertEqual(length, 4, 'len of hero_list error!%d_%d' % (length, 4))
        hero = player.hero_list.get_hero_by_no(10011)
        self.assertFalse(hero == None, 'add error!')
        self.assertEqual(hero.level, 11)
        self.assertEqual(hero.break_level, 2)
        self.assertEqual(hero.exp, 1)
        self.assertEqual(hero.equipment_ids, [])


    def remove_hero_test(self):
        pass

    def get_all_exp_test(self):
        pass

    def upgrade_test(self):
        pass

    def save_data_test(self):
        pass
