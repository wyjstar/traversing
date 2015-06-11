#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
world boss.
"""
import unittest
import test.unittest.init_data.init_connection
from app.game.service.gatenoteservice import remoteservice
from app.game.core.PlayersManager import PlayersManager
from app.proto_file import login_gift_pb2

class LoginGiftTest(unittest.TestCase):
    """docstring for WorldBossTest"""
    def __init__(self):
        super(LoginGiftTest, self).__init__()

    def setUp(self):
        from test.unittest.init_test_data import init
        init()
        self.player = PlayersManager().get_player_by_id(1)

    def test_init_login_gift_825(self):
        str_response = remoteservice.callTarget(825, 1, "")

        response = login_gift_pb2.LineUpResponse()
        response = login_gift_pb2.InitLoginGiftResponse()
        response.ParseFromString(str_response)
        print(response)


