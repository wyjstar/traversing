# -*- coding:utf-8 -*-
"""
created by wzp.
"""
from robot import Robot
from app.proto_file import pvp_rank_pb2
import gevent

class RobotPvp(Robot):

    def command_fight(self):
        arg = pvp_rank_pb2.PvpFightRequest()
        arg.challenge_rank = 1
        line_up = arg.lineup.add()
        line_up.pos = 1
        line_up.hero_id = 10046
        line_up = arg.lineup.add()
        line_up.pos = 2
        line_up.hero_id = 10029
        line_up = arg.lineup.add()
        line_up.pos = 3
        line_up.hero_id = 10043
        line_up = arg.lineup.add()
        line_up.pos = 4
        line_up.hero_id = 0
        line_up = arg.lineup.add()
        line_up.pos = 5
        line_up.hero_id = 0
        line_up = arg.lineup.add()
        line_up.pos = 6
        line_up.hero_id = 0

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


