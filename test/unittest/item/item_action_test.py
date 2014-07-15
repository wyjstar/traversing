# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午4:28.
"""

import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.action.node.item import *
from app.game.service.gatenoteservice import remoteservice
from app.proto_file.item_pb2 import ItemPB
from app.proto_file.player_response_pb2 import GameResourcesResponse


class ItemActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_use_item_302(self):
        """测试两个box"""
        item_pb = ItemPB()
        item_pb.item_no = 1000112
        item_pb.item_num = 2
        game_resources_response_str = remoteservice.callTarget(302, 1, item_pb.SerializeToString())
        game_resources_response = GameResourcesResponse()
        game_resources_response.ParseFromString(game_resources_response_str)

        self.assertEqual(game_resources_response.finance.coin, 2000)

