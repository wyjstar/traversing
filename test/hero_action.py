# -*- coding:utf-8 -*-
"""
created by server on 14-6-23上午11:59.
"""
#coding:utf8

import struct

from twisted.internet import reactor, protocol

from app.proto_file.hero_response_pb2 import GetHerosResponse
from app.proto_file.hero_chip_pb2 import GetHeroChipsResponse
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from app.proto_file.equipment_request_pb2 import GetEquipmentsRequest
from app.proto_file.equipment_response_pb2 import GetEquipmentResponse


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
    print 'len:', len(sendstr)
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
    #print command, message

    return command, message

# a client protocol
times = 0
class EchoClient(protocol.Protocol):
    """Once connected, send a message, then print the result."""

    def dateSend(self, argument, command_id):
        self.transport.write(sendData(argument, command_id))

    def connectionMade(self):

        self.dateSend("", 101)

    def dataReceived(self, data):
        "As soon as any data is received, write it back."

        command, message = resolveRecvdata(data)

        print data
        print "+++++++++++++++++++++++++++"

        if command == 101:
            #print message, "?????"
            argument = GetHerosResponse()
            argument.ParseFromString(message)
            print argument.heros[0].hero_no
            #self.dateSend("", 108)
        if command == 199:
            print message, "199???????"

        if command == 108:
            argument = GetHeroChipsResponse()
            argument.ParseFromString(message)
            print ">>>>>>>>>>>>>>>>>>"
            print argument.hero_chips[0].hero_chip_no
            print argument.hero_chips[1].hero_chip_no

            shop_request = ShopRequest()
            shop_request.id = 1001
            self.dateSend(shop_request.SerializeToString(), 501)

        if command == 501:
            argument = ShopResponse()
            argument.ParseFromString(message)
            print argument


            request = GetEquipmentsRequest()
            request.type = 0
            self.dateSend(request.SerializeToString(), 401)

        if command == 401:

            print message, "message401"
            response = GetEquipmentResponse()
            response.ParseFromString(message)

            print "len", len(response.equipment)
            self.dateSend('', 88)

        if command == 88:
            print "????"
            print "recv88", message






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