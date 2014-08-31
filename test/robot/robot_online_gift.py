# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from robot import Robot
from app.proto_file import online_gift_pb2


class RobotOnlineGift(Robot):
    def command_get_online_gift(self):
        request = online_gift_pb2.GetOnlineGift()
        request.gift_id = 1
        self.send_message(request, 1121)

    def get_fnd_402(self, message):
        self.on_command_finish()
