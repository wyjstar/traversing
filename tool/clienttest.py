#coding:utf8

import time
from gfirefly.netconnect.datapack import DataPackProtoc

from socket import AF_INET,SOCK_STREAM,socket
from thread import start_new
import struct,json
HOST='127.0.0.1'
PORT=11009
BUFSIZE=1024
ADDR=(HOST , PORT)
client = socket(AF_INET,SOCK_STREAM)
client.connect(ADDR)


def sendData(sendstr,commandId):
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
    head = struct.unpack('!sssss3I', data[:17])
    length = head[6]
    data = data[17:17+length]
    return data

def login():
    senddata = sendData(json.dumps({"username":"test106","password":"111111"}), 101)
    client.sendall(senddata)
    print resolveRecvdata(client.recv(2048))


def rolelogin():
    token = "tokencode123456"
    print "我想要登录游戏，我的token是：", token
    senddata = sendData(json.dumps({"token": token}), 4)
    client.sendall(senddata)
    returndata = client.recv(2048)
    print 'returndata', returndata
    data = resolveRecvdata(returndata)
    if not data:
        print "no data return."
    print "result:", data
    data = eval(data)
    result = data.get('result')
    message = data.get('message')
    print "data:", data.get('data')
    if not result and message == 'no_role':
        create_character()
    else:
        print data.get('data')


def create_character():
    token = "tokencode123456"
    nickname = raw_input("请输入你的昵称：")
    senddata = sendData(json.dumps({"token": token, 'nickname': nickname}), 5)
    client.sendall(senddata)
    data = resolveRecvdata(client.recv(2048))
    print data


#login()
rolelogin()
while True:
    pass