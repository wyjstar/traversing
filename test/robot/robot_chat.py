# -*- coding:utf-8 -*-
"""
created by server on 14-9-12上午11:35.
"""
from app.proto_file.chat_pb2 import ChatResponse, ChatConectingRequest
from robot import Robot


class RobotChat(Robot):
    def command_chat(self):
        argument1 = ChatConectingRequest()
        argument1.owner.id = self.id
        argument1.owner.nickname = self.nickname
        argument1.channel = 2
        argument1.content = "nihaohnihaonihaihoani.nihao"
        argument1.guild_id = u"abc"
        self.send_message(argument1, 1002)

    def chat_1000(self, message):
        argument = ChatResponse()
        argument.ParseFromString(message)
        print argument
        self.on_command_finish()