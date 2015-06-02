# -*- coding:utf-8 -*-
"""
created by server on 15-5-27下午2:00.
"""
__author__ = 'Server-ZhangChao'

from robot import Robot

from app.proto_file import Share_pb2
from app.proto_file.lively_pb2 import rewardResponse


class RobotZhangChao(Robot):
    def command_get_share_status(self):
        request = Share_pb2.ClientGetShareStatusData()
        self.send_message(request, 2300)

    def command_get_share_reward(self):
        request = Share_pb2.ClientGetShareReward()
        request.task_id = 4000001
        self.send_message(request, 2301)

    def c2s_2300(self, message):
        print("#"*66, "Recv Msg 2300")
        response = Share_pb2.ServerShareStatusData()
        response.ParseFromString(message)
        print(response)
        self.on_command_finish()

    def c2s_2301(self, message):
        print("#"*66, "Recv Msg 2301")
        result = rewardResponse()
        result.ParseFromString(message)
        print(result.res.result)
        print(result.res.message)
        self.on_command_finish()


