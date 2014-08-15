# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:29.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.logic.shop import is_consume
import time
from shared.db_opear.configs_data.game_configs import shop_config


class ShopTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_is_consume(self):
        self.player.last_pick_time.fine_hero = time.time()
        shop_item = shop_config.get(1001)
        result = is_consume(self.player, shop_item)
        self.assertTrue(result)

        shop_item = shop_config.get(1002)
        result = is_consume(self.player, shop_item)
        self.assertTrue(result)

        shop_item = shop_config.get(1003)
        result = is_consume(self.player, shop_item)
        self.assertFalse(result)

        shop_item = shop_config.get(1004)
        result = is_consume(self.player, shop_item)
        self.assertTrue(result)

        shop_item = shop_config.get(1005)
        result = is_consume(self.player, shop_item)
        self.assertFalse(result)