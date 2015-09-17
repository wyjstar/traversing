# -*- coding:utf-8 -*-
"""
created by server on 14-7-14下午8:04.
"""

import test.unittest.init_data.init_connection
import unittest
from app.game.action.node.line_up import *
from app.proto_file.line_up_pb2 import *
from app.game.core.PlayersManager import PlayersManager
from app.proto_file import line_up_pb2
from app.proto_file import player_request_pb2
from test.unittest.test_tool import call


class LineUpActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        self.player = init()

    def tst_get_line_up_info_701(self):
        str_response = get_line_up_info(1)
        response = line_up_pb2.LineUpResponse()
        response.ParseFromString(str_response)

        slot = response.slot[0]
        self.assertEqual(slot.hero.hero_no, 10001, "%d_%d" % (slot.hero.hero_no, 10001))
        self.assertEqual(slot.activation, True)
        for i in range(0, 6):
            print i+1, slot.equs[i].equ.id
        self.assertEqual(slot.equs[3].equ.id, "", "%s_%s" % (slot.equs[3].equ.id, ""))

        slot5 = response.slot[4]
        self.assertEqual(slot5.hero.hero_no, 0, "%d_%d" % (slot5.hero.hero_no, 0))
        self.assertEqual(slot5.activation, False)




        print(slot5.hero, "hero")
        print (slot5.hero.hero_no)
        print (slot5.hero.level)
        print type(response.res), "res"

        # response = line_up_pb2.LineUpResponse()
        # slot = response.slot.add()
        # # slot.slot_no = 1
        # slot.activation = False
        # data = response.SerializePartialToString()
        # response = line_up_pb2.LineUpResponse()
        # response.ParseFromString(data)
        #
        # slot = response.slot[0]
        # print (slot.hero, "????")
        # print (slot.activation, "????")
        # print (response.res, "res")
        # print (response.res.result, "res")
        # print (response.res.result_no, "res")
        # print (response.res.message, "message")

    def tst_change_hero_702(self):
        request = ChangeHeroRequest()
        request.hero_no = 10003
        request.slot_no = 1
        request.change_type = 1
        str_response = call(702, request.SerializeToString())

        response = line_up_pb2.LineUpResponse()
        response.ParseFromString(str_response)

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.sub_slots[1]
        self.assertEqual(line_up_slot.hero_slot.hero_no, 10003, "%d_%d" % (line_up_slot.hero_slot.hero_no, 10003))
        self.assertEqual(response.sub[0].hero.hero_no, 10003, "%d_%d" % (response.sub[0].hero.hero_no, 10003))

    def tst_change_equipments_703(self):
        equipments = self.player.equipment_component.get_all()
        last_equipment_id = equipments[len(equipments)-1].base_info.id

        request = ChangeEquipmentsRequest()
        request.slot_no = 1
        request.no = 1
        request.equipment_id = last_equipment_id

        remoteservice.callTarget(703, 1, request.SerializeToString())

        line_up_component = self.player.line_up_component
        line_up_slot = line_up_component.line_up_slots[1]


    def test_change_line_up_order_704(self):
        pass
        # request = ChangeLineUpOrderRequest()
        # order = [2, 1, 3, 4, 6, 5]
        # [request.line_up_order.append(x) for x in order]
        # remoteservice.callTarget(704, 1, request.SerializeToString())
        #
        # line_up_order = self.player.line_up_component.line_up_order
        # self.assertEqual(line_up_order[2], 3, "%d_%d" % (line_up_order[2], 3))

    def test_set_caption_709(self):
        """
        """
        request = SetCaptainRequest()
        request.caption_pos = 5
        str_response = call(709, request.SerializeToString())

    def test_set_caption_2203(self):
        """
        """
        request = player_request_pb2.ButtonOneTimeRequest()
        request.button_id = 0
        str_response = call(2203, request.SerializeToString())


if __name__ == '__main__':
    unittest.main()
