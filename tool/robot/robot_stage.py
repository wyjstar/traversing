# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import stage_request_pb2
from app.proto_file import stage_response_pb2

class RobotStage(Robot):

    def command_fight(self):
        arg = stage_request_pb2.StageStartRequest()
        arg.stage_id = 100101
        arg.stage_type = 1
        line_up = arg.lineup.add()
        line_up.pos = 1
        line_up.hero_id = 10044
        line_up = arg.lineup.add()
        line_up.pos = 2
        line_up.hero_id = 10045
        line_up = arg.lineup.add()
        line_up.pos = 3
        line_up.hero_id = 10046
        line_up = arg.lineup.add()
        line_up.pos = 4
        line_up.hero_id = 0
        line_up = arg.lineup.add()
        line_up.pos = 5
        line_up.hero_id = 0
        line_up = arg.lineup.add()
        line_up.pos = 6
        line_up.hero_id = 0

        self.send_message(arg, 903)

    def fight_903(self, message):
        response = stage_response_pb2.StageStartResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()
