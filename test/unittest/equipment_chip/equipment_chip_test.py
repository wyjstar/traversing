# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午6:30.
"""
from test.unittest.base.base_test_case import BaseTestCase

class EquipmentChipTest(BaseTestCase):
    """test heros_component and hero"""
    def test_num(self):
        """docstring for test_cnum"""
        self.Equal(len(self.player.equipment_chip_component.get_all()), 63)
