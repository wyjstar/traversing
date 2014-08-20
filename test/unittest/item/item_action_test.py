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
from app.proto_file.item_response_pb2 import GetItemsResponse, ItemUseResponse


class ItemActionTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_get_items_301(self):
        """取得全部道具"""
        response_str = remoteservice.callTarget(301, 1)
        response = GetItemsResponse()
        response.ParseFromString(response_str)
        items = response.items
        self.assertEqual(len(items), 7, "%d_%d" % (len(items), 7))
        self.assertEqual(items[6].item_no, 1000113, "%d_%d" % (items[6].item_no, 1000113))
        self.assertEqual(items[6].item_num, 15, "%d_%d" % (items[6].item_num, 15))

    def test_use_item_302(self):
        """测试两个box"""
        item_pb = ItemPB()
        item_pb.item_no = 1000112
        item_pb.item_num = 2
        game_resources_response_str = remoteservice.callTarget(302, 1, item_pb.SerializeToString())
        response = ItemUseResponse()
        response.ParseFromString(game_resources_response_str)
        self.assertEqual(response.res.result, True)
        self.assertEqual(response.gain.finance.coin, 2000)

        item = self.player.item_package.get_item(item_pb.item_no)
        self.assertEqual(item.num, 13)


        game_resources_response_str = remoteservice.callTarget(302, 1, item_pb.SerializeToString())
        response = ItemUseResponse()
        response.ParseFromString(game_resources_response_str)
        self.assertEqual(response.res.result, True)
        self.assertEqual(response.gain.finance.coin, 2000)

        item = self.player.item_package.get_item(item_pb.item_no)
        self.assertEqual(item.num, 11)

        item_pb = ItemPB()
        item_pb.item_no = 1000112
        item_pb.item_num = 10000
        game_resources_response_str = remoteservice.callTarget(302, 1, item_pb.SerializeToString())
        response = ItemUseResponse()
        response.ParseFromString(game_resources_response_str)
        self.assertEqual(response.res.result, False)

