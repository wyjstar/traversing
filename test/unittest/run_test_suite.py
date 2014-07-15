# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午5:37.
"""

from test.unittest.hero.hero_action_test import HeroActionTest
from test.unittest.hero.hero_test import HeroTest
from test.unittest.hero_chip.hero_chip_test import HeroChipTest
from test.unittest.equipment.equipmnet_test import EquipmentTest
from test.unittest.line_up.line_up_test import LineUpTest
from test.unittest.line_up.line_up_action_test import LineUpActionTest
from test.unittest.item.item_action_test import ItemActionTest
from test.unittest.drop_bag.drop_bag_test import DropBagTest

import unittest

if __name__ == "__main__":
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(HeroActionTest))
    suite.addTest(unittest.makeSuite(HeroTest))
    suite.addTest(unittest.makeSuite(HeroChipTest))
    suite.addTest(unittest.makeSuite(EquipmentTest))
    suite.addTest(unittest.makeSuite(ItemActionTest))
    # suite.addTest(unittest.makeSuite(LineUpTest))
    # suite.addTest(unittest.makeSuite(LineUpActionTest))
    suite.addTest(unittest.makeSuite(DropBagTest))
    unittest.TextTestRunner().run(suite)


