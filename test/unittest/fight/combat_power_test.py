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
        print break_attr
        self.NotEqual(break_attr, {})

    def test_travel_attr(self):
        travel_attr = self.player.travel_component.get_travel_item_attr()
        self.NotEqual(travel_attr, {})

    def test_equip_attr(self):
        line_up_slot= self.player.line_up_component.line_up_slots.get(2)
        print "---", line_up_slot.equ_attr()
        self.NotEqual(line_up_slot.equ_attr(), [])
