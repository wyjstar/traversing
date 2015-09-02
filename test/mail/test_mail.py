# -*- coding:utf-8 -*-
"""
created by server on 14-6-23上午11:59.
"""
#coding:utf8

import struct

from twisted.internet import reactor, protocol
from app.proto_file import item_pb2
from app.proto_file import account_pb2
from app.proto_file import equipment_pb2
from app.proto_file.player_request_pb2 import PlayerLoginRequest
from app.proto_file.player_response_pb2 import PlayerResponse
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.mailbox_pb2 import *
from app.proto_file.account_pb2 import AccountResponse, AccountLoginRequest
from app.proto_file.game_pb2 import GameLoginRequest, GameLoginResponse
from app.proto_file.hero_response_pb2 import GetHerosResponse


def sendData(sendstr,commandId):
    '''定义协议头
    '''
    HEAD_0 = chr(0)
    HEAD_1 = chr(0)
    HEAD_2 = chr(0)
    HEAD_3 = chr(0)
    ProtoVersion = chr(0)
    ServerVersion = 0
    sendstr = sendstr

    data = struct.pack('!sssss3I',HEAD_0,HEAD_1,HEAD_2,\
                       HEAD_3,ProtoVersion,ServerVersion,\
                       len(sendstr)+4,commandId)
    senddata = data+sendstr
    return senddata

def resolveRecvdata(data):
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
    message = data[17:17+lenght]
    # print command, message
    print "长度", command, 17+lenght

    return command, message, data[17+lenght:]

# a client protocol
times = 0
class EchoClient(protocol.Protocol):
    """Once connected, send a message, then print the result."""
    def __init__(self):
        self.buff = ''

    def dateSend(self, argument, command_id):
        self.transport.write(sendData(argument.SerializeToString(), command_id))

    def connectionMade(self):

        # 帐号登录

        argument = account_pb2.AccountLoginRequest()
        argument.key.key = '06656fe419bd1d9799f220d2fce0b439'

        # argument.user_name = 'ghh0001'
        # argument.password = '123457'

        self.dateSend(argument, 2)

    def dataReceived(self, data):
        "As soon as any data is received, write it back."
        self.buff += data
        print 'data', len(data)
        while self.buff:
            self.handle()

    def handle(self):
        command, message, self.buff = resolveRecvdata(self.buff)
        print "buff", self.buff, "buff"
        player_id = 0
        if command == 2:

            argument = AccountResponse()
            argument.ParseFromString(message)
            print argument

            request = GameLoginRequest()
            request.token = argument.key.key
            self.dateSend(request, 4)

        if command == 4:
            argument = GameLoginResponse()
            argument.ParseFromString(message)
            player_id = argument.id
            send_mail_request = SendMailRequest()
            mail = send_mail_request.mail
            mail.mail_id = '001'
            mail.sender_id = player_id
            mail.sender_name = 'player1'
            mail.receive_id = player_id
            mail.receive_name = 'player1'
            mail.title = 'title1'
            mail.content = 'content1'
            mail.mail_type = 4

            self.dateSend(send_mail_request, 1304)

        if command == 1304:
            response = CommonResponse()
            response.ParseFromString(message)
            print "send response:", response.result

        if command == 1305:
            response = ReceiveMailResponse()
            response.ParseFromString(message)
            print "receive response:", response.mail



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