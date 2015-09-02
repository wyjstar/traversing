# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import pvp_rank_pb2

class RobotPvp(Robot):

    def command_fight(self):
        arg = pvp_rank_pb2.PvpFightRequest()
        arg.challenge_rank = 1
        for i in range(1, 7):
            arg.lineup.append(i)

        self.send_message(arg, 1505)

    def fight_1505(self, message):
        response = pvp_rank_pb2.PvpFightResponse()
        response.ParseFromString(message)
        print response
        #gevent.sleep(1)
        self.command_fight()

        #self.on_command_finish()

    def on_character_login_result(self, result):
        print "*"*80
        self.command_fight()

    def on_login(self):
        print "*"*80
        self.command_fight()
