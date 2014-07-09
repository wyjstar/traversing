# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午5:37.
"""

from test.unittest.hero.hero_action_test import HeroActionTest
from test.unittest.hero.hero_test import HeroTest
from test.unittest.hero_chip.hero_chip_test import HeroChipTest
import unittest

if __name__ == "__main__":
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(HeroActionTest))
    suite.addTest(unittest.makeSuite(HeroTest))
    suite.addTest(unittest.makeSuite(HeroChipTest))
    unittest.TextTestRunner().run(suite)


