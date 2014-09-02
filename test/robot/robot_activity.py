# -*- coding:utf-8 -*-
"""
created by server on 14-9-2上午11:42.
"""
from app.proto_file.feast_pb2 import EatFeastResponse
from robot import Robot
from app.proto_file import online_gift_pb2


class RobotActivity(Robot):
    def command_get_online_gift(self):
        request = online_gift_pb2.GetOnlineGift()
        request.gift_id = 25
        self.send_message(request, 1121)

    def get_online_gift_1121(self, message):
        response = online_gift_pb2.GetOnlineGiftResponse()
        response.ParseFromString(message)
        print 'result:', response.result
        self.on_command_finish()

    def command_eat_feast(self, hello):
        self.send_message(None, 820)

    def eat_feast_820(self, message):
        argument = EatFeastResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()