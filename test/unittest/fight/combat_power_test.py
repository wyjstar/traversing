#!/usr/bin/env python
# -*- coding: utf-8 -*-

from test.unittest.base.base_test_case import BaseTestCase
from app.game.component.fight.hero_attr_cal import combat_power

class CombatPowerTest(BaseTestCase):
    """docstring for CombatPowerTest"""

    def test_skill_attr(self):
        """docstring for fname"""
        hero = self.player.hero_component.get_hero(10045)
        hero_info = hero.hero_info

        break_attr = combat_power.skill_attr(hero, hero_info, hero.break_skill_ids)
        self.NotEqual(break_attr, {})
