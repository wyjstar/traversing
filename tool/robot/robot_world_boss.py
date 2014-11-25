# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file.world_boss_pb2 import PvbBeforeInfoResponse, EncourageHerosRequest, PvbFightResponse
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.stage_request_pb2 import StageStartRequest

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

    def reborn_1704(self, message):
        response = CommonResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()

    def command_fight(self):
        argument1 = StageStartRequest()
        argument1.stage_id = 800101
        # argument1.fid = 1120
        line_up = argument1.lineup.add()
        line_up.pos = 1
        line_up.hero_id = 10005
        line_up = argument1.lineup.add()
        line_up.pos = 2
        line_up.hero_id = 10029
        line_up = argument1.lineup.add()
        line_up.pos = 3
        line_up.hero_id = 10043
        line_up = argument1.lineup.add()
        line_up.pos = 4
        line_up.hero_id = 0
        line_up = argument1.lineup.add()
        line_up.pos = 5
        line_up.hero_id = 0
        line_up = argument1.lineup.add()
        line_up.pos = 6
        line_up.hero_id = 0

        self.send_message(argument1, 1705)

    def fight_1705(self, message):
        response = PvbFightResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()
