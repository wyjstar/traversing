# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午6:30.
"""
from gfirefly.distributed.node import RemoteObject
from gfirefly.server.globalobject import GlobalObject
import test.unittest.init_data.init_connection
import unittest
from app.game.redis_mode import tb_character_friend
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.friend import *
from app.proto_file.friend_pb2 import FriendCommon


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

    def test_friend_function(self):

        # GlobalObject().remote['gate'] = RemoteObject('game')

        print '==========friend test beging=========='


        request = FriendCommon()
        response = CommonResponse()

        print '==========become friend=========='
        request.target_id = 1
        result = become_friends(self.player2.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 1, "become friend error!%s" % response.result)
        self.print_friend_data([1, 2])

        print '==========add friend request=========='
        request.target_id = 2
        result = add_friend_request(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 0, "friend error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========re-add friend request=========='
        request.target_id = 2
        result = add_friend_request(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 1, "friend error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========become friend=========='
        request.target_id = 1
        result = become_friends(self.player2.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 0, "become friend error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========del friend=========='
        request.target_id = 1
        result = del_friend(self.player2.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 0, "del friend error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========re-del friend=========='
        request.target_id = 1
        result = del_friend(self.player2.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 1, "del friend error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========del blacklist=========='
        request.target_id = 3
        result = del_player_from_blacklist(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 1, "del blacklist error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========add blacklist=========='
        request.target_id = 3
        result = add_player_to_blacklist(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 0, "add blacklist error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========re-add blacklist=========='
        request.target_id = 3
        result = add_player_to_blacklist(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 1, "re-add blacklist error!%d" % response.result)
        self.print_friend_data([1, 2])

        print '==========del blacklist=========='
        request.target_id = 3
        result = del_player_from_blacklist(self.player1.base_info.id, request.SerializePartialToString())
        response.ParseFromString(result)
        self.assertEqual(response.result, 0, "del blacklist error!%d" % response.result)
        self.print_friend_data([1, 2])
