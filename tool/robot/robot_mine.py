# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import mine_pb2

class RobotMine(Robot):
    def command_trigger_boss(self):
        self.send_message("", 1259)

    def trigger_boss_1707(self, message):
        response = mine_pb2.StageStartResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()
