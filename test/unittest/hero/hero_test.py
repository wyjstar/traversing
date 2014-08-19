# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""

import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
import cPickle
from app.game.redis_mode import *
from app.game.core.hero import Hero


class HeroTest(unittest.TestCase):
    """test heros_component and hero"""

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_add_hero(self):
        hero = self.player.hero_component.add_hero(10011)
        hero.hero_no = 10011
        hero.level = 11
        hero.break_level = 2
        hero.exp = 1
        hero.equipment_ids = []
        hero.save_data()
        length = len(self.player.hero_component.get_heros())
        self.assertEqual(length, 7, 'len of hero_list error!%d_%d' % (length, 7))
        hero = self.player.hero_component.get_hero(10011)
        self.assertFalse(hero == None, 'add error!')
        self.assertEqual(hero.level, 11)
        self.assertEqual(hero.break_level, 2)
        self.assertEqual(hero.exp, 1, 'exp %d' % hero.exp)

        #redis
        heros = tb_character_heros.getObjData(1)
        length = len(heros.get('hero_ids'))
        self.assertEqual(length, 7, 'len of hero_list error!%d_%d' % (length, 7))

        hero_id = self.player.hero_component.get_hero_id(10011)
        hero_in_redis = tb_character_hero.getObjData(hero_id)
        hero = self.player.hero_component.get_hero(10011)
        self.assertEqual(hero_in_redis.get('character_id'), 1)

        hero_property = hero_in_redis.get('property')
        self.assertEqual(hero_property.get('level'), 11)
        self.assertEqual(hero_property.get('break_level'), 2)
        self.assertEqual(hero_property.get('exp'), 1, 'exp %d' % hero.exp)

    def test_remove_hero(self):
        self.player.hero_component.delete_hero(10001)
        hero = self.player.hero_component.get_hero(10001)
        self.assertEqual(hero, None)

        #redis
        heros = tb_character_heros.getObjData(1)
        length = len(heros.get('hero_ids'))
        self.assertEqual(length, 5, 'len of hero_list error!%d_%d' % (length, 5))

    def test_get_all_exp(self):
        hero = self.player.hero_component.get_hero(10001)
        all_exp = hero.get_all_exp()
        self.assertEqual(all_exp, 5501, "get_all_exp error!%d_%d" % (all_exp, 5501))

    def test_upgrade(self):
        hero = self.player.hero_component.get_hero(10001)
        hero.upgrade(3000)
        self.assertEqual(hero.level, 13, "error!%d_%d" % (hero.level, 13))
        self.assertEqual(hero.exp, 701, "error!%d_%d" % (hero.exp, 701))

    def test_save_data(self):
        hero = self.player.hero_component.get_hero(10002)
        hero.level = 10
        hero.break_level = 11
        hero.exp = 13
        hero.equipment_ids = [1, 2]
        hero.save_data()

        hero_id = self.player.hero_component.get_hero_id(10002)
        hero_in_redis = tb_character_hero.getObjData(hero_id)
        hero_property = hero_in_redis.get('property')
        self.assertEqual(hero_property.get('level'), 10)
        self.assertEqual(hero_property.get('break_level'), 11)
        self.assertEqual(hero_property.get('exp'), 13, 'exp %d' % hero.exp)



