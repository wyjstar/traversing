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
from app.game.redis_mode import tb_equipment_info
from app.game.service.gatenoteservice import remoteservice
from app.proto_file.equipment_request_pb2 import GetEquipmentsRequest
from app.proto_file.equipment_response_pb2 import GetEquipmentResponse


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