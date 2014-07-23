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
        self.player1 = PlayersManager().get_player_by_id(1)
        self.player2 = PlayersManager().get_player_by_id(2)

    def print_friend_data(self, player_id):
        for i in player_id:
            friend_data = tb_character_friend.getObjData(i)
            print '>>>>>>player_id', i, friend_data

    def test_get_equipment_chips(self):
        print '==========friend test beging=========='

        # become_friends(self.player2.base_info.id, 1)

        print '==========add friend request=========='
        add_friend_request(self.player1.base_info.id, 2)
        self.print_friend_data([1, 2])

        print '==========become friend=========='
        become_friends(self.player2.base_info.id, 1)
        self.print_friend_data([1, 2])
