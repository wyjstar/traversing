# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午6:12.
"""

from test.unittest.base.base_test_case import BaseTestCase
import unittest

class LineUpTest(BaseTestCase):
    """test heros_component and hero"""

    def test_add_hero(self):
        line_up_component = self.player.line_up_component
        line_up_component.change_hero(2, 10001, 1)

    def test_hero_link(self):
        line_up_slot = self.player.line_up_component.line_up_slots.get(2)
        hero_slot = line_up_slot.hero_slot
        self.NotEqual(hero_slot.link_skill_ids, [])

    def test_set_equip(self):
        line_up_slot = self.player.line_up_component.line_up_slots.get(2)
        self.NotEqual(line_up_slot.set_equ_skill_ids, [])

if __name__ == '__main__':
    unittest.main()
