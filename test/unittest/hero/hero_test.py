# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""
from test.unittest.base.base_test_case import BaseTestCase

class HeroTest(BaseTestCase):
    """test heros_component and hero"""

    def add_hero(self):
        hero = self.player.hero_component.add_hero(10011)
        hero.hero_no = 10011
        hero.level = 11
        hero.break_level = 2
        hero.exp = 1

    def test_remove_hero(self):
        self.player.hero_component.delete_hero(10001)
        hero = self.player.hero_component.get_hero(10001)
        self.assertEqual(hero, None)

    def test_get_all_exp(self):
        hero = self.player.hero_component.get_hero(10001)
        all_exp = hero.get_all_exp()
        self.assertEqual(all_exp, 0, "get_all_exp error!%d_%d" % (all_exp, 5501))

    def test_upgrade(self):
        hero = self.player.hero_component.get_hero(10001)
        hero.upgrade(3000, 5)
        self.assertEqual(hero.level, 5, "error!%d_%d" % (hero.level, 5))
        self.assertEqual(hero.exp, 30, "error!%d_%d" % (hero.exp, 30))

    def test_break_skill_ids(self):
        """docstring for test_break_skill_idsfname"""
        hero = self.player.hero_component.get_hero(10045)

        self.Equal(len(hero.break_skill_ids), 7)

    def test_runt(self):
        hero = self.player.hero_component.get_hero(10045)
        runt_attr = hero.runt_attr()
        print runt_attr

