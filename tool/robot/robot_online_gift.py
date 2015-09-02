# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from robot import Robot
from app.proto_file import online_gift_pb2
from app.proto_file import login_gift_pb2


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

    def command_init_login_gift_825(self):
        self.send_message("", 825)

    def test_init_login_gift_825(self, message):
        response = login_gift_pb2.InitLoginGiftResponse()
        response.ParseFromString(message)
        print 'result:', response
        self.on_command_finish()

    def command_get_login_gift_826(self):
        request = login_gift_pb2.GetLoginGiftRequest()
        request.activity_id = 1001
        request.activity_type = 1

        self.send_message(request, 826)

    def test_get_login_gift_826(self, message):
        response = login_gift_pb2.GetLoginGiftResponse()
        response.ParseFromString(message)
        print 'result:', response
        self.on_command_finish()
