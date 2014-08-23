# -*- coding:utf-8 -*-
"""
created by server on 14-8-8下午2:45.
"""

import struct
from twisted.internet import reactor, protocol
from twisted.internet.protocol import ClientCreator
from app.proto_file import account_pb2
from app.proto_file import player_request_pb2
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.game_pb2 import GameLoginResponse
from app.proto_file import friend_pb2

# HOST = '192.168.10.186'
HOST = 'localhost'
PORT = 11009
MAX_LOGIN_CLIENT = 5000
MAX_LOGIN_QUEUE = 200
USER_NAME = 'test'  # 'test32'
PASSWORD = '123456'  # pwd  # '123456'
NICKNAME = 'nick'  # 'bab5'


def build_data(send_str, command_id):
    HEAD_0 = chr(0)
    HEAD_1 = chr(0)
    HEAD_2 = chr(0)
    HEAD_3 = chr(0)
    ProtoVersion = chr(0)
    ServerVersion = 0
    send_str = send_str
    data = struct.pack('!sssss3I', HEAD_0, HEAD_1, HEAD_2,
                       HEAD_3, ProtoVersion, ServerVersion,
                       len(send_str) + 4, command_id)
    result_data = data + send_str
    return result_data


def resolve_receive_data(data):
    ud = struct.unpack('!sssss3I', data[:17])
    # HEAD_0 = ord(ud[0])
    # HEAD_1 = ord(ud[1])
    # HEAD_2 = ord(ud[2])
    # HEAD_3 = ord(ud[3])
    # protoVersion = ord(ud[4])
    # serverVersion = ud[5]
    lenght = ud[6]
    command = ud[7]
    message = data[17:17 + lenght]
    return command, message


class SimulatorLogin(protocol.Protocol):
    LOGIN_SUCCESS_COUNT = 0
    LOGIN_FAIL_COUNT = 0
    LOGIN_PROCESSING = 0

    def __init__(self, user_name, pwd, nickname):

        SimulatorLogin.LOGIN_PROCESSING += 1
        self._times = 0
        self._user_name = user_name  # 'test32'
        self._password = pwd  # '123456'
        self._nickname = nickname  # 'bab5'
        self._distributor = {}

        for attr in dir(self):
            key = attr.split('_')[-1]
            if key.isdigit():
                self._distributor[key] = attr
        # print self._distributor

    def send_message(self, argument, command_id):
        self.transport.write(build_data(argument.SerializeToString(),
                                        command_id))

    def connectionMade(self):
        # 帐号注册： 游客
        argument = account_pb2.AccountInfo()
        argument.user_name = self._user_name
        argument.password = self._password
        argument.type = 2
        self.send_message(argument, 1)

    def dataReceived(self, data):
        command, message = resolve_receive_data(data)
        # print command
        fun = getattr(self, self._distributor[str(command)])
        if fun:
            fun(message)
        else:
            SimulatorLogin.LOGIN_FAIL_COUNT += 1
            SimulatorLogin.LOGIN_PROCESSING -= 1
            print 'cant find processor by command:', command

    def acount_register_1(self, message):
        argument = account_pb2.AccountResponse()
        argument.ParseFromString(message)
        # print 'account register', argument.result

        argument = account_pb2.AccountLoginRequest()
        argument.user_name = self._user_name
        argument.password = self._password
        argument.key.key = ''
        self.send_message(argument, 2)

    def account_login_2(self, message):
        response = account_pb2.AccountResponse()
        response.ParseFromString(message)
        print 'login request result:', response.result

        request = player_request_pb2.PlayerLoginRequest()
        request.token = 'ea93b955c76de71380559058cdcd6932'
        self.send_message(request, 4)
        if not response.result:
            SimulatorLogin.LOGIN_FAIL_COUNT += 1

    def character_login_4(self, message):
        argument = GameLoginResponse()
        argument.ParseFromString(message)
        format_str = 'character login result:%s nickname:%s level;%s'
        print format_str % (argument.res.result,
                            argument.nickname,
                            argument.level)

        SimulatorLogin.LOGIN_PROCESSING -= 1
        SimulatorLogin.LOGIN_SUCCESS_COUNT += 1

        # get friend list
        request = friend_pb2.FriendCommon()
        self.send_message(request, 1106)

    def change_nickname_5(self, message):
        response = CommonResponse()
        response.ParseFromString(message)
        print 'change nickname result:', response.result

    def get_friend_list_1106(self, message):
        # get friend list
        response = friend_pb2.GetPlayerFriendsResponse()
        response.ParseFromString(message)
        # print 'get friends list:'
        for _ in response.friends:
            print 'friend:', _
        for _ in response.blacklist:
            print 'blacklist:', _
        for _ in response.applicant_list:
            print 'applicant list:', _
        # get friend list
        request = friend_pb2.FriendCommon()
        self.send_message(request, 1106)

    def connectionLost(self, reason):
        SimulatorLogin.LOGIN_PROCESSING -= 1
        SimulatorLogin.LOGIN_FAIL_COUNT += 1
        print "connection lost"


def run(num):
    count = SimulatorLogin.LOGIN_FAIL_COUNT + SimulatorLogin.LOGIN_SUCCESS_COUNT
    if count < MAX_LOGIN_CLIENT \
            and SimulatorLogin.LOGIN_PROCESSING < MAX_LOGIN_QUEUE:
        user_name = '%s%d' % (USER_NAME, num)
        nickname = '%s%d' % (NICKNAME, num)
        print 'add client:', user_name, nickname
        c = ClientCreator(reactor,
                          SimulatorLogin,
                          user_name,
                          PASSWORD,
                          nickname)
        c.connectTCP(HOST, PORT)
        num += 1
    reactor.callLater(0, run, num)


def tick():
    print 'login success:%d login fail:%d login queue:%d' % \
          (SimulatorLogin.LOGIN_SUCCESS_COUNT,
           SimulatorLogin.LOGIN_FAIL_COUNT,
           SimulatorLogin.LOGIN_PROCESSING)
    reactor.callLater(1, tick)


# this connects the protocol to a server runing on port 8000
def main():
    count = 1
    reactor.callLater(0, run, count)
    reactor.callLater(1, tick)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
