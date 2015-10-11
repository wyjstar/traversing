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
        # gevent.sleep(1)
    #     self.command_fight()

        self.on_command_finish()

    # def on_character_login_result(self, result):
    #     print "*"*80
    #     self.command_fight()

    # def on_login(self):
    #     print "*"*80
    #     self.command_fight()

    def command_fight_overcome(self, index):
        request = pvp_rank_pb2.PvpFightOvercome()
        request.index = int(index)
        for i in range(1, 7):
            request.lineup.append(i)

        self.send_message(request, 1508)

    def fight_1508(self, message):
        response = pvp_rank_pb2.PvpFightResponse()
        response.ParseFromString(message)
        print response
        # gevent.sleep(1)
        # self.command_fight()
        self.on_command_finish()

    def command_fight_overcome_award(self, index):
        request = pvp_rank_pb2.PvpOvercomeAwardRequest()
        request.index = int(index)

        self.send_message(request, 1510)

    def fight_1510(self, message):
        response = pvp_rank_pb2.PvpOvercomeAwardResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()

    def command_fight_overcome_buff(self, index, num):
        request = pvp_rank_pb2.GetPvpOvercomeBuffRequest()
        request.index = int(index)
        request.num = int(num)

        self.send_message(request, 1511)

    def fight_1511(self, message):
        response = pvp_rank_pb2.GetPvpOvercomeBuffResponse()
        response.ParseFromString(message)
        print response
        self.on_command_finish()
