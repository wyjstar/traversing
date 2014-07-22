# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午6:30.
"""
import test.unittest.init_data.init_connection
import unittest
from app.game.redis_mode import tb_character_friend
from app.game.core.PlayersManager import PlayersManager
from app.game.core.friend import *
# from app.proto_file.friend_pb2 import *


class FriendTest(unittest.TestCase):
    def setUp(self):
        from test.unittest.init_test_data import init

        init()
        self.player = PlayersManager().get_player_by_id(1)


    def test_get_equipment_chips(self):
        print 'friend test beging'
        add_friend_request(1, 2)


