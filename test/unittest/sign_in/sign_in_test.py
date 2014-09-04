# -*- coding:utf-8 -*-
"""
created by server on 14-8-26下午3:32.
"""
import test.unittest.init_data.init_connection
from app.game.core.PlayersManager import PlayersManager
import unittest
from app.game.logic.sign_in import *
from app.proto_file.sign_in_pb2 import SignInResponse


class SignInTest(unittest.TestCase):

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_sign_in_1401(self):
        response_data = sign_in(1)
        response = SignInResponse()
        response.ParseFromString(response_data)

        self.assertTrue(response.res.result)
        self.assertEqual(self.player.finance.coin, 31000, "%d_%d" % (self.player.finance.coin, 31000))

    def test_continuous_sign_in_1402(self):
        """连续签到"""
        self.player.sign_in_component.continuous_sign_in_days = 8
        response_data = continuous_sign_in(1, 7)
        response = ContinuousSignInResponse()
        response.ParseFromString(response_data)
        self.assertTrue(response.res.result)
        self.assertEqual(self.player.finance.coin, 31000, "%d_%d" % (self.player.finance.coin, 31000))

    def test_repair_sign_in_1403(self):
        """补签到"""
        response_data = repair_sign_in(1, 1)
        response = SignInResponse()
        response.ParseFromString(response_data)

        self.assertTrue(response.res.result)
        self.assertEqual(self.player.finance.gold, 9950, "%d_%d" % (self.player.finance.gold, 9950))
        self.assertEqual(self.player.sign_in_component.repair_sign_in_times, 1, "%d_%d" % (self.player.sign_in_component.repair_sign_in_times, 1))
