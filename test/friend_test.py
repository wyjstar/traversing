# coding:utf8

import struct
from twisted.internet import reactor, protocol
from app.proto_file import account_pb2
from app.proto_file import player_request_pb2
from app.proto_file.game_pb2 import GameLoginResponse
from app.proto_file.player_response_pb2 import PlayerResponse
from app.proto_file.friend_pb2 import *


def send_data(send_str, command_id):
    '''定义协议头
    '''
    HEAD_0 = chr(0)
    HEAD_1 = chr(0)
    HEAD_2 = chr(0)
    HEAD_3 = chr(0)
    ProtoVersion = chr(0)
    ServerVersion = 0
    send_str = send_str
    print 'len:', len(send_str)
    data = struct.pack('!sssss3I', HEAD_0, HEAD_1, HEAD_2,
                       HEAD_3, ProtoVersion, ServerVersion,
                       len(send_str) + 4, command_id)
    result_data = data + send_str
    return result_data


def resolve_receive_data(data):
    '''解析数据，根据定义的协议头解析服务器返回的数据
    '''
    ud = struct.unpack('!sssss3I', data[:17])
    HEAD_0 = ord(ud[0])
    HEAD_1 = ord(ud[1])
    HEAD_2 = ord(ud[2])
    HEAD_3 = ord(ud[3])
    protoVersion = ord(ud[4])
    serverVersion = ud[5]
    lenght = ud[6]
    command = ud[7]
    message = data[17:17 + lenght]
    print 'command:', command
    print 'message:', message
    return command, message

# a client protocol
times = 0


class EchoClient(protocol.Protocol):

    def __init__(self):
        self._times = 0
        self._user_name = 'test3'
        self._password = '111'

    """Once connected, send a message, then print the result."""

    def send_message(self, argument, command_id):
        self.transport.write(send_data(argument.SerializeToString(), command_id))

    def connectionMade(self):
        # 帐号注册： 游客
        argument = account_pb2.AccountInfo()
        argument.user_name = self._user_name
        argument.password = self._password
        argument.type = 2
        self.send_message(argument, 1)

    def dataReceived(self, data):

        command, message = resolve_receive_data(data)
        if command == 1:

            argument = account_pb2.AccountResponse()
            argument.ParseFromString(message)
            print '===argument===', argument

            argument = account_pb2.AccountLoginRequest()
            argument.user_name = self._user_name
            argument.password = self._password
            argument.key.key = ''
            self.send_message(argument, 2)

        if command == 2:
            argument = account_pb2.AccountResponse()
            argument.ParseFromString(message)
            print 'login request result:', argument.result

            argument = player_request_pb2.PlayerLoginRequest()
            argument.token = 'ea93b955c76de71380559058cdcd6932'
            self.send_message(argument, 4)

        if command == 4:
            argument = GameLoginResponse()
            argument.ParseFromString(message)
            print 'nickname:', argument.naickname, 'level:', argument.level

            request = FriendCommon()
            request.target_id = 2
            self.send_message(request, 1106)

    def connectionLost(self, reason):
        print "connection lost"


class EchoFactory(protocol.ClientFactory):
    protocol = EchoClient

    def clientConnectionFailed(self, connector, reason):
        print "Connection failed - goodbye!"
        reactor.stop()

    def clientConnectionLost(self, connector, reason):
        print "Connection lost - goodbye!"
        reactor.stop()


# this connects the protocol to a server runing on port 8000
def main():
    HOST = 'localhost'
    PORT = 11009

    f = EchoFactory()
    reactor.connectTCP(HOST, PORT, f)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()