# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""
from test.unittest.init_test_data import init
init()
from test.unittest.init_data.mock_player import player

import unittest
import cPickle
from app.game.redis_mode import *
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
        hero.exp = 1
        hero.equipment_ids = []
        player.hero_list.add_hero(hero)
        length = len(player.hero_list.get_heros())
        self.assertEqual(length, 4, 'len of hero_list error!%d_%d' % (length, 4))
        hero = player.hero_list.get_hero_by_no(10011)
        self.assertFalse(hero == None, 'add error!')
        self.assertEqual(hero.level, 11)
        self.assertEqual(hero.break_level, 2)
        self.assertEqual(hero.exp, 1, 'exp %d' % hero.exp)
        self.assertEqual(hero.equipment_ids, [])

        #redis
        heros = tb_character_heros.getObjData(1)
        length = len(heros.get('hero_ids'))
        self.assertEqual(length, 4, 'len of hero_list error!%d_%d' % (length, 4))

        hero_id = player.hero_list.get_hero_id(10011)
        hero_in_redis = tb_character_hero.getObjData(hero_id)
        hero = player.hero_list.get_hero_by_no(10011)
        self.assertEqual(hero_in_redis.get('character_id'), 1)

        hero_property = hero_in_redis.get('property')
        self.assertEqual(hero_property.get('level'), 11)
        self.assertEqual(hero_property.get('break_level'), 2)
        self.assertEqual(hero_property.get('exp'), 1, 'exp %d' % hero.exp)
        self.assertEqual(cPickle.loads(hero_property.get('equipment_ids')), [])

    def remove_hero_test(self):
        player.hero_list.remove_hero(10001)
        hero = player.hero_list.get_hero_by_no(10001)
        self.assertEqual(hero, None)

        #redis
        heros = tb_character_heros.getObjData(1)
        length = len(heros.get('hero_ids'))
        self.assertEqual(length, 4, 'len of hero_list error!%d_%d' % (length, 4))

    def get_all_exp_test(self):
        hero = player.hero_list.get_hero_by_no(10001)
        all_exp = hero.get_all_exp()
        self.assertEqual(all_exp, 5501, "get_all_exp_test error!%d_%d" % (all_exp, 5501))

    def upgrade_test(self):
        hero = player.hero_list.get_hero_by_no(10001)
        hero.upgrade(3000)
        self.assertEqual(hero.level, 13, "error!%d_%d" % (hero.level, 13))
        self.assertEqual(hero.exp, 701, "error!%d_%d" % (hero.exp, 701))

    def save_data_test(self):
        hero = player.hero_list.get_hero_by_no(10001)
        hero.level = 10
        hero.break_level = 11
        hero.exp = 13
        hero.equipment_ids = [1, 2]
        hero.save_data()

        hero_id = player.hero_list.get_hero_id(10001)
        hero_in_redis = tb_character_hero.getObjData(hero_id)
        hero_property = hero_in_redis.get('property')
        self.assertEqual(hero_property.get('level'), 10)
        self.assertEqual(hero_property.get('break_level'), 11)
        self.assertEqual(hero_property.get('exp'), 13, 'exp %d' % hero.exp)
        self.assertEqual(cPickle.loads(hero_property.get('equipment_ids')), [1, 2])



