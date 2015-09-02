# -*- coding:utf-8 -*-
"""
created by server on 14-8-4下午2:49.
"""

# -*- coding:utf-8 -*-
"""
created by server on 14-7-10下午5:06.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.service.gatenoteservice import remoteservice
from app.proto_file.equipment_request_pb2 import GetEquipmentsRequest, ComposeEquipmentRequest, EnhanceEquipmentRequest
from app.proto_file.equipment_response_pb2 import GetEquipmentResponse, ComposeEquipmentResponse, EnhanceEquipmentResponse
from app.game.action.node.equipment import *


class EquipmentTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_equipments(self):
        request = GetEquipmentsRequest()
        request.type = 0

        # str_response = remoteservice.callTarget(401, 1, request.SerializeToString())
        # print str_response, "str_response"
        # response = GetEquipmentResponse()
        # response.ParseFromString(str_response)
        # list_len = len(response.equipment)
        # self.assertEqual(list_len, 2, "return len error!%d" % list_len)

    def test_compose_equipments(self):
        request = ComposeEquipmentRequest()
        request.no = 1000112

        str_response = remoteservice.callTarget(403, 1, request.SerializeToString())
        print str_response, "str_response"
        response = ComposeEquipmentResponse()
        response.ParseFromString(str_response)
        self.assertEqual(response.res.result, True)
        self.assertEqual(response.equ.no, 100001, "%d_%d" % (response.equ.no, 100001))

    def test_enhance_equipments(self):
        request = EnhanceEquipmentRequest()
        request.id = "001115"
        request.type = 1
        request.num = 1

        str_response = remoteservice.callTarget(402, 1, request.SerializeToString())
        response = EnhanceEquipmentResponse()
        response.ParseFromString(str_response)
        self.assertEqual(response.res.result, True)
        self.assertEqual(response.data[0].before_lv, 0, "%d_%d" % (response.data[0].before_lv, 0))
        self.assertEqual(response.data[0].after_lv, 1, "%d_%d" % (response.data[0].after_lv, 1))
        self.assertEqual(response.data[0].cost_coin, 16, "%d_%d" % (response.data[0].after_lv, 16))
