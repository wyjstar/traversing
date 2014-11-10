# -*- coding:utf-8 -*-
"""
created by server on 14-9-2上午11:42.
"""
from app.proto_file.feast_pb2 import EatFeastResponse
from robot import Robot
from app.proto_file import online_gift_pb2
from app.proto_file import level_gift_pb2
from app.proto_file import pvp_rank_pb2
from app.proto_file import line_up_pb2
from app.proto_file import soul_shop_pb2


class RobotActivity(Robot):
    # online gift
    def command_get_online_gift(self, gift_id):
        request = online_gift_pb2.GetOnlineGift()
        request.gift_id = int(gift_id)
        self.send_message(request, 1121)

    def get_online_gift_1121(self, message):
        response = online_gift_pb2.GetOnlineGiftResponse()
        response.ParseFromString(message)
        print 'result:', response.result
        print 'gain:', response.gain
        self.on_command_finish()

    # level gift
    def command_get_level_gift(self, gift_id):
        request = level_gift_pb2.GetLevelGift()
        request.gift_id = int(gift_id)
        self.send_message(request, 1131)

    def get_level_gift_1131(self, message):
        response = level_gift_pb2.GetLevelGiftResponse()
        response.ParseFromString(message)
        print 'result:', response.result
        print 'gain:', response.gain
        self.on_command_finish()

    def command_get_online_level_gift_data(self):
        self.send_message(None, 1120)

    def get_online_level_gift_data_1120(self, message):
        response = online_gift_pb2.GetOnlineLevelGiftData()
        response.ParseFromString(message)
        print 'online time:', response.online_time
        for _ in response.received_online_gift_id:
            print 'received online gift:', _
        for _ in response.received_level_gift_id:
            print 'received online gift:', _
        self.on_command_finish()

    def command_eat_feast(self, hello):
        self.send_message(None, 820)

    def eat_feast_820(self, message):
        argument = EatFeastResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_pvp_player_info(self, rank):
        request = pvp_rank_pb2.PvpPlayerInfoRequest()
        request.player_rank = int(rank)
        self.send_message(request, 1504)

    def get_player_info_1504(self, message):
        response = line_up_pb2.LineUpResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()

    def command_pvp_top_rank(self):
        self.send_message(None, 1501)

    def command_pvp_player_rank(self):
        self.send_message(None, 1502)

    def command_pvp_player_rank_refresh(self):
        self.send_message(None, 1503)

    def get_player_info_1501(self, message):
        response = pvp_rank_pb2.PlayerRankResponse()
        response.ParseFromString(message)
        for _ in response.rank_items:
            print _.nickname, _.rank
        self.on_command_finish()

    def get_player_info_1502(self, message):
        response = pvp_rank_pb2.PlayerRankResponse()
        response.ParseFromString(message)
        for _ in response.rank_items:
            print _.nickname, _.rank
        self.on_command_finish()

    def get_player_info_1503(self, message):
        response = pvp_rank_pb2.PlayerRankResponse()
        response.ParseFromString(message)
        for _ in response.rank_items:
            print _.nickname, _.rank
        self.on_command_finish()

    def command_pvp_fight_player(self, rank):
        request = pvp_rank_pb2.PvpFightRequest()
        request.challenge_rank = int(rank)
        self.send_message(request, 1505)

    def get_fight_response_1505(self, message):
        response = pvp_rank_pb2.PvpFightResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()

    def command_arena_shop_refresh(self):
        self.send_message(None, 1511)

    def get_arena_shop_response_1511(self, message):
        response = soul_shop_pb2.GetShopItemsResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()

    def command_get_arena_shop(self):
        self.send_message(None, 1512)

    def get_arena_shop_response_1512(self, message):
        response = soul_shop_pb2.GetShopItemsResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()
