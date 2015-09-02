# -*- coding:utf-8 -*-
"""
created by server on 14-7-8下午5:37.
"""

from test.unittest.hero.hero_action_test import HeroActionTest
from test.unittest.hero.hero_test import HeroTest
from test.unittest.hero_chip.hero_chip_test import HeroChipTest
from test.unittest.equipment.equipmnet_test import EquipmentTest
from test.unittest.equipment_chip.equipment_chip_test import EquipmentChipTest
from test.unittest.line_up.line_up_test import LineUpTest
from test.unittest.line_up.line_up_action_test import LineUpActionTest
from test.unittest.item.item_action_test import ItemActionTest
from test.unittest.drop_bag.drop_bag_test import DropBagTest
from test.unittest.logic.item_group_helper_test import ItemGroupHelperTest
from test.unittest.soul_shop.soul_shop_test import SoulShopTest
from test.unittest.shop.shop_test import ShopTest
from test.unittest.friend.friend_test import FriendTest

import unittest

if __name__ == "__main__":
    suite = unittest.TestSuite()
    suite.addTest(unittest.makeSuite(HeroActionTest))
    suite.addTest(unittest.makeSuite(HeroTest))
    suite.addTest(unittest.makeSuite(HeroChipTest))
    suite.addTest(unittest.makeSuite(EquipmentTest))
    suite.addTest(unittest.makeSuite(EquipmentChipTest))
    suite.addTest(unittest.makeSuite(ItemActionTest))
    # suite.addTest(unittest.makeSuite(LineUpTest))
    suite.addTest(unittest.makeSuite(LineUpActionTest))
    suite.addTest(unittest.makeSuite(DropBagTest))
    suite.addTest(unittest.makeSuite(ItemGroupHelperTest))
    suite.addTest(unittest.makeSuite(ShopTest))
    suite.addTest(unittest.makeSuite(SoulShopTest))
    suite.addTest(unittest.makeSuite(FriendTest))
    unittest.TextTestRunner().run(suite)


