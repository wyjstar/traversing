# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from robot import Robot
from app.proto_file import online_gift_pb2


class RobotOnlineGift(Robot):
    def command_get_online_gift(self):
        request = online_gift_pb2.GetOnlineGift()
        request.gift_id = 25
        self.send_message(request, 1121)

    def get_online_gift_1121(self, message):
        response = online_gift_pb2.GetOnlineGiftResponse()
        response.ParseFromString(message)
        print 'result:', response.result
        print 'gain:', response.gain
        self.on_command_finish()
