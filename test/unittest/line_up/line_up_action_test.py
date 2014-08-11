# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午8:04.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.action.node.line_up import *
from app.game.service.gatenoteservice import remoteservice
from app.proto_file.line_up_pb2 import *
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.line_up import get_line_up_info
from app.proto_file import line_up_pb2


class LineUpActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)
        # self.add_hero(10001)
        # self.add_hero(10002)

    def test_get_line_up_info_701(self):
        str_response = get_line_up_info(1)
        response = line_up_pb2.LineUpResponse()
        response.ParseFromString(str_response)

        slot = response.slot[0]
        self.assertEqual(slot.hero.hero_no, 10001, "%d_%d" % (slot.hero.hero_no, 10001))
        self.assertEqual(slot.activation, True)

        slot = response.slot[5]
        self.assertEqual(slot.hero.hero_no, 0, "%d_%d" % (slot.hero.hero_no, 0))
        self.assertEqual(slot.activation, False)

    def test_change_hero_702(self):
        request = ChangeHeroRequest()
        request.hero_no = 10003
        request.slot_no = 1
        remoteservice.callTarget(702, 1, request.SerializeToString())

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.line_up_slots[1]
        self.assertEqual(line_up_slot.hero_no, 10003, "%d_%d" % (line_up_slot.hero_no, 10003))

    def test_change_equipments_703(self):
        equipments = self.player.equipment_component.get_all()
        last_equipment_id = equipments[len(equipments)-1].base_info.id

        request = ChangeEquipmentsRequest()
        request.slot_no = 1
        request.no = 1
        request.equipment_id = last_equipment_id

        remoteservice.callTarget(703, 1, request.SerializeToString())

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.line_up_slots[1]
        self.assertEqual(line_up_slot.equipment_ids[1], last_equipment_id, "%s_%s" %
                         (line_up_slot.equipment_ids[1], last_equipment_id))

    def test_change_line_up_order_704(self):
        pass
        # request = ChangeLineUpOrderRequest()
        # order = [2, 1, 3, 4, 6, 5]
        # [request.line_up_order.append(x) for x in order]
        # remoteservice.callTarget(704, 1, request.SerializeToString())
        #
        # line_up_order = self.player.line_up_component.line_up_order
        # self.assertEqual(line_up_order[2], 3, "%d_%d" % (line_up_order[2], 3))

