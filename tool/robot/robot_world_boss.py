# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file.world_boss_pb2 import PvbBeforeInfoResponse, EncourageHerosRequest, PvbFightResponse
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file import world_boss_pb2, common_pb2

class RobotWorldBoss(Robot):

    def command_get_before_fight_info(self):
        request = world_boss_pb2.PvbRequest()
        request.boss_id = "world_boss"
        self.send_message(request, 1701)

    def get_1701(self, message):
        argument = PvbBeforeInfoResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()

    def command_encourage(self):
        request = EncourageHerosRequest()
        request.boss_id = "world_boss"
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
        argument1 = world_boss_pb2.PvbStartRequest()
        argument1.boss_id = "world_boss"
        # argument1.fid = 1120
        line_up = argument1.lineup.add()
        line_up.pos = 1
        line_up.hero_id = 10046
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

    def command_trigger_boss(self):
        self.send_message("", 1259)

    def trigger_boss_1259(self, message):
        response = common_pb2.CommonResponse()
        response.ParseFromString(message)
        print response
        #self.on_command_finish()

    def trigger_boss_1707(self, message):
        response = world_boss_pb2.MineBossResponse()
        response.ParseFromString(message)
        print response

        request = world_boss_pb2.PvbRequest()
        request.boss_id = response.boss_id
        self.send_message(request, 1701)

        # self.on_command_finish()
