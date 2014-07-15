# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午8:04.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.action.node.line_up import *
from app.game.service.gatenoteservice import remoteservice
from app.proto_file.line_up_pb2 import *


class LineUpActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)
        self.add_hero(10001)
        self.add_hero(10002)

    def test_add_hero_701(self):
        self.add_hero(10003)

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.get_line_up_slot(3)
        self.assertEqual(line_up_slot.hero_no, 10003, "%d_%d" % (line_up_slot.hero_no, 10003))
        self.assertEqual(len(line_up_component.line_up_order), 3, "%d_%d" % (len(line_up_component.line_up_order), 3))
        self.assertEqual(line_up_component.line_up_order[2], 3, "%d_%d" % (line_up_component.line_up_order[2], 3))

    def test_change_hero_702(self):
        request = ChangeHeroRequest()
        request.hero_no = 10003
        request.line_up_slot_id = 1
        remoteservice.callTarget(702, 1, request.SerializeToString())

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.get_line_up_slot(1)
        self.assertEqual(line_up_slot.hero_no, 10003, "%d_%d" % (line_up_slot.hero_no, 10003))
        self.assertEqual(len(line_up_component.line_up_order), 2, "%d_%d" % (len(line_up_component.line_up_order), 2))
        self.assertEqual(line_up_component.line_up_order[0], 1, "%d_%d" % (line_up_component.line_up_order[0], 1))

    def test_change_equipments_703(self):
        equipments = self.player.equipment_component.get_all()

        request = ChangeEquipmentsRequest()
        request.line_up_slot_id = 1
        for item in equipments:
            request.equipment_ids.append(item.base_info.id)
        else:
            for i in range(6-len(equipments)):
                request.equipment_ids.append('')
        remoteservice.callTarget(703, 1, request.SerializeToString())

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.get_line_up_slot(1)
        self.assertEqual(len(line_up_slot.equipment_ids), 6, "%d_%d" % (len(line_up_slot.equipment_ids), 6))
        self.assertEqual(line_up_slot.equipment_ids[1], equipments[1].base_info.id, "%s_%s" %
                         (line_up_slot.equipment_ids[1], equipments[1].base_info.id))

    def test_change_line_up_order_704(self):
        request = ChangeLineUpOrderRequest()
        order = [2, 1, 3, 4, 6, 5]
        [request.line_up_order.append(x) for x in order]
        remoteservice.callTarget(704, 1, request.SerializeToString())

        line_up_order = self.player.line_up_component.line_up_order
        self.assertEqual(line_up_order[2], 3, "%d_%d" % (line_up_order[2], 3))

    def add_hero(self, hero_no):
        request = AddHeroRequest()
        request.hero_no = hero_no
        remoteservice.callTarget(701, 1, request.SerializeToString())