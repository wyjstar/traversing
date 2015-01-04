# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:16.
"""
from test.unittest.base.base_test_case import BaseTestCase

class PlayerTest(BaseTestCase):
    def test_add_exp(self):
        """
        level:60, exp:0
        """
        self.player.level.addexp(8200)
        self.Equal(self.player.level.level, 62)
        self.Equal(self.player.level.exp, 0)
