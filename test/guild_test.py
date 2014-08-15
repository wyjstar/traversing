#coding:utf8

import struct
import time
from twisted.internet import reactor, protocol
from app.proto_file import account_pb2
from app.proto_file.player_request_pb2 import PlayerLoginRequest
from app.proto_file.player_response_pb2 import PlayerResponse
from app.proto_file.guild_pb2 import *
    # CreateGuildRequest, \
    # JoinGuildRequest, \
    # EditorCallRequest, GuildCommonResponse, \
    # GuildInfoProto

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
    print 'command:', command
    print 'message:', message
    return command, message

# a client protocol
times = 0
class EchoClient(protocol.Protocol):

    _times = 0

    """Once connected, send a message, then print the result."""

    def dateSend(self, argument, command_id):
        self.transport.write(sendData(argument.SerializeToString(), command_id))

    def connectionMade(self):

        # # 帐号注册： 游客
        # argument = account_pb2.AccountInfo()
        # argument.type = 1
        # self.dateSend(argument, 1)
        argument = account_pb2.AccountLoginRequest()
        argument.key.key = 'cf038c8f6fd618b86aac3cd86fcde05d'
        # argument.user_name = 'ceshi3'
        # argument.password = 'ceshi1'
        self.dateSend(argument, 2)

    def dataReceived(self, data):
        "As soon as any data is received, write it back."
        command, message = resolveRecvdata(data)
        if command == 1:

            argument = account_pb2.AccountResponse()
            argument.ParseFromString(message)
            print argument

            # 帐号注册： 帐号
            if not self._times:
                argument = account_pb2.AccountInfo()
                argument.type = 2
                argument.user_name = 'ceshi4'
                argument.password = 'ceshi1'
                self.dateSend(argument, 1)

                self._times += 1
            else:
                argument = account_pb2.AccountLoginRequest()
                argument.key.key = 'cf038c8f6fd618b86aac3cd86fcde05d'
                # argument.user_name = 'ceshi3'
                # argument.password = 'ceshi1'
                self.dateSend(argument, 2)

        if command == 2:
            argument = account_pb2.AccountResponse()
            argument.ParseFromString(message)
            print argument

            argument = PlayerLoginRequest()
            argument.token = 'cf038c8f6fd618b86aac3cd86fcde05d'
            self.dateSend(argument, 4)

        if command == 4:
            argument = PlayerResponse()
            argument.ParseFromString(message)
            print argument

            # 41eaaaa61e1bd68cf4b6657628f08951
            # f8a5f34048fa591a2c4fea89cd5f7eaf
            # 43014583c182bcbf37f7de4569a857d6 申请加入

            # --------801创建公会------------
            argument1 = CreateGuildRequest()
            argument1.name = '一二三四001'
            self.dateSend(argument1, 801)

            # --------802加入公会------------
            # argument1 = JoinGuildRequest()
            # argument1.g_id = 'a84403fa22d011e48b48080027545076'
            # self.dateSend(argument1, 802)

            # --------803退出公会------------
            # argument1 = CreateGuildRequest()
            # argument1.name = '一二三四129'
            # self.dateSend(argument1, 803)

            # --------804编辑公告------------
            # argument1 = EditorCallRequest()
            # argument1.call = 'aaaaaa空间弗兰克道具弗具弗阿里空间弗兰克道具弗阿里空间弗兰克道具弗'
            # self.dateSend(argument1, 804)

            # --------805处理加入公会申请------------
            # argument1 = DealApplyRequest()
            # argument1.p_ids.append(539)
            # argument1.res_type = 1
            # self.dateSend(argument1, 805)

            # --------806转让会长------------
            # argument1 = ChangePresidentRequest()
            # argument1.p_id = 500
            # self.dateSend(argument1, 806)

            # --------807踢人------------
            # argument1 = KickRequest()
            # argument1.p_ids.append(123)
            # argument1.p_ids.append(123)
            # argument1.p_ids.append(456)
            # argument1.p_ids.append(789)
            # self.dateSend(argument1, 807)

            # --------808晋升------------
            # argument1 = WorshipRequest()
            # argument1.w_type = 1
            # self.dateSend(argument1, 808)

            # --------809膜拜------------
            # argument1 = WorshipRequest()
            # argument1.w_type = 1
            # self.dateSend(argument1, 809)

            # --------812获取公会信息---------
            # argument1 = CreateGuildRequest()
            # argument1.name = '一二三四117'
            # self.dateSend(argument1, 812)

            # --------811获取公会玩家列表---------
            # argument1 = CreateGuildRequest()
            # argument1.name = '一二三四117'
            # self.dateSend(argument1, 811)

            # --------813获取申请列表---------
            # argument1 = CreateGuildRequest()
            # argument1.name = '一二三四117'
            # self.dateSend(argument1, 813)

            # --------810获取公会排行---------
            # argument1 = CreateGuildRequest()
            # argument1.name = '一二三四117'
            # self.dateSend(argument1, 810)

        if command == 801:
            # 创建公会
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 802:
            # 加入公会
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 803:
            # 退出公会
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 804:
            # 编辑公告
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 806:
            # 转让公会
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 807:
            # 踢人
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 809:
            # 膜拜
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

        if command == 812:
            # 获取公会信息
            argument = GuildInfoProto()
            argument.ParseFromString(message)
            print argument

        if command == 813:
            # 获取申请信息
            argument = ApplyListProto()
            argument.ParseFromString(message)
            print argument

        if command == 811:
            # 获取公会玩家列表
            argument = GuildRoleListProto()
            argument.ParseFromString(message)
            print argument

        if command == 810:
            # 获取公会排行
            argument = GuildRankProto()
            argument.ParseFromString(message)
            print argument

        if command == 805:
            #
            argument = GuildCommonResponse()
            argument.ParseFromString(message)
            print argument

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