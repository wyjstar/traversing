# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file.world_boss_pb2 import PvbBeforeInfoResponse, EncourageHerosRequest
from app.proto_file.common_pb2 import CommonResponse

class RobotWorldBoss(Robot):

    def command_get_before_fight_info(self):
        self.send_message("", 1701)

    def get_1701(self, message):
        argument = PvbBeforeInfoResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_encourage(self):
        request = EncourageHerosRequest()
        request.finance_type = 1
        request.finance_num = 2
        self.send_message(request, 1703)

    def encourage_1703(self, message):
        response = CommonResponse()
        response.ParseFromString(message)
        print response

        self.on_command_finish()

    def reborn_1704(self):
        self.on_command_finish()
