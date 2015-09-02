# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午6:30.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.redis_mode import tb_character_equipment_chip
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.equipment_chip import get_equipment_chips
from app.proto_file.equipment_chip_pb2 import GetEquipmentChipsResponse


class EquipmentChipTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init

        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_init_data(self):
        data = tb_character_equipment_chip.getObj(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        print ">>>>>>>>>>>>>>>>"
        print data.get("chips"), data
        num = data.get('chips').get(1000112)
        self.assertEqual(num, 300, "chip num error!%d_%d" % (num, 300))

    def test_save_data(self):
        hero_chip = self.player.equipment_chip_component.get_chip(1000112)
        hero_chip.num = 1000
        self.player.equipment_chip_component.save_data()
        data = tb_character_equipment_chip.getObj(1)
        self.assertEqual(data.get('id'), 1, "player id error!")
        num = data.get('chips').get(1000112)
        self.assertEqual(num, 300, "chip num error!%d_%d" % (num, 300))

    def test_get_equipment_chips(self):
        response_str = get_equipment_chips(1)
        response = GetEquipmentChipsResponse()
        response.ParseFromString(response_str)

        lst = [x for x in response.equipment_chips]
        self.assertEqual(len(lst), 4, "%d_%d" % (len(lst), 4))
