# -*- coding:utf-8 -*-
"""
created by server on 14-8-8下午2:45.
"""
from robotbase import RobotBase
from app.proto_file import account_pb2
from app.proto_file import player_request_pb2
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.game_pb2 import GameLoginResponse
from app.proto_file.player_request_pb2 import CreatePlayerRequest


class Robot(RobotBase):
    # def __init__(self):
    #     self.id = 0
    #     self.nickname = ''

    def __init__(self, socket, manager, passport, nickname):
        RobotBase.__init__(self, socket)

        self.on_connection_made = self.connection_made
        self.on_account_login_result = None
        # self.on_character_login_result = None

        self._passport = passport
        self._nickname = nickname  # 'bab5'
        manager.register_robot(self)
        self.connection_made()

    def connection_made(self):
        argument = account_pb2.AccountLoginRequest()
        print 'connection made', self._passport
        argument.passport = self._passport
        self.send_message(argument, 2)

    # def acount_register_1(self, message):
    #     argument = account_pb2.AccountResponse()
    #     argument.ParseFromString(message)
    #     print 'account register', argument.result
        #
        # argument = account_pb2.AccountLoginRequest()
        # argument.passport = self._passport
        # self.send_message(argument, 2)

    def account_login_2(self, message):
        response = account_pb2.AccountResponse()
        response.ParseFromString(message)
        print 'login request result:', response.result
        self.on_account_login_result(response.result)

        request = player_request_pb2.PlayerLoginRequest()
        request.token = 'ea93b955c76de71380559058cdcd6932'
        self.send_message(request, 4)

    def character_login_4(self, message):
        argument = GameLoginResponse()
        argument.ParseFromString(message)
        format_str = 'character login result:%s id:%d nickname:%s level;%s'
        print format_str % (argument.res.result,
                            argument.id,
                            argument.nickname,
                            argument.level)
        if not argument.res.result:
            self.on_character_login_result(argument.res.result)

        self.id = argument.id
        self.nickname = argument.nickname
        request = CreatePlayerRequest()
        request.nickname = self._nickname
        self.send_message(request, 5)

    def change_nickname_5(self, message):
        response = CommonResponse()
        response.ParseFromString(message)
        print 'change nickname result:', response.result
        # print "-+"*40, self.__class__, self.on_character_login_result
        if self.on_character_login_result:
            self.on_character_login_result(True)
        if hasattr(self, 'on_login'):
            self.on_login()

    def abc_1234(self, message):
        if self.on_command_finish:
            self.on_command_finish()

    def none_1824(self, message):
        pass
