#-*- coding:utf-8 -*-
"""
created by server on 14-5-17下午2:59.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('chatgate')
def push_message(send_list, message):
    """向客户端发送信息
    """
    from app.chat.proto_file.chat import chat_pb2
    argument = chat_pb2.chatMessageResponse()
    argument.ParseFromString(message)
    GlobalObject().netfactory.pushObject(1000, message, send_list)