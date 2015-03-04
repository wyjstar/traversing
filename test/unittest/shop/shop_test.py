# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:29.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.logic.shop import is_consume, shop_oper
import time
from shared.db_opear.configs_data import game_configs
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse


class ShopTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_is_consume(self):
        self.player.last_pick_time.fine_hero = time.time()
        shop_item = game_configs.shop_config.get(10001)
        result = is_consume(self.player, shop_item)
        self.assertTrue(result)

        request = ShopRequest()
        request.id = 10002
        response_data = shop_oper(1, request.SerializePartialToString())
        response = ShopResponse()
        response.ParseFromString(response_data)
        print "gain", response.gain
