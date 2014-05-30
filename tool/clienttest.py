#coding:utf8

import struct
from twisted.internet import reactor, protocol
from app.chat.proto_file.chat import chat_pb2

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
    ud = struct.unpack('!sssss3I',data[:17])
    HEAD_0 = ord(ud[0])
    HEAD_1 = ord(ud[1])
    HEAD_2 = ord(ud[2])
    HEAD_3 = ord(ud[3])
    protoVersion = ord(ud[4])
    serverVersion = ud[5]
    lenght = ud[6]
    command = ud[7]
    message = data[17:17+lenght]
    return command, message

# a client protocol
times = 0
class EchoClient(protocol.Protocol):
    """Once connected, send a message, then print the result."""

    def dateSend(self, argument, command_id):
        self.transport.write(sendData(argument.SerializeToString(), command_id))

    def connectionMade(self):

        argument = chat_pb2.LoginToChatRequest()
        owner = argument.owner
        owner.id = 1
        owner.nickname = 'haihe'

        self.dateSend(argument, 1)

    def dataReceived(self, data):
        "As soon as any data is received, write it back."
        command, message = resolveRecvdata(data)
        if command == 1:
            argument = chat_pb2.ChatResponse()
            argument.ParseFromString(message)
            print argument

            argument = chat_pb2.ChatConectingRequest()
            owner = argument.owner
            owner.id = 1
            owner.nickname = 'haihe'
            argument.channel = 1
            argument.content = 'hello,beibei'

            self.dateSend(argument, 2)

        if command == 2:
            argument = chat_pb2.ChatResponse()
            argument.ParseFromString(message)
            print '2', argument

            global times
            while not times:
                argument = chat_pb2.ChatConectingRequest()
                owner = argument.owner
                owner.id = 1
                owner.nickname = 'haihe'

                other = argument.other
                other.id = 1
                other.nickname = 'haihe'

                argument.channel = 3
                argument.content = 'hello,beibei'

                self.dateSend(argument, 2)
                times += 1

        if command == 1000:
            argument = chat_pb2.chatMessageResponse()
            argument.ParseFromString(message)
            print '1000', argument

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
    PORT = 11010

    f = EchoFactory()
    reactor.connectTCP(HOST, PORT, f)
    reactor.run()

# this only runs if the module was *not* imported
if __name__ == '__main__':
    main()
    # from redisco.tests import all_tests
    # print all_tests()
