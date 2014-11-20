# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file.world_boss_pb2 import PvbGetBeforeFightResponse



class RobotWorldBoss(Robot):

    def command_get_before_fight_info(self):
        self.send_message("", 1701)

    def get_1701(self, message):
        argument = PvbGetBeforeFightResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()
