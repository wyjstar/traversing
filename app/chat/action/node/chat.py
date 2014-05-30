#-*- coding:utf-8 -*-
"""
created by server on 14-5-20下午8:33.
"""
from app.chat.proto_file.chat import chat_pb2
from app.chat.service.local.local_service import localservice
from app.chat.service.node.chatgateservice import nodeservice_handle


@nodeservice_handle
def send_message_2(command_id, dynamic_id, request_proto):
    """发送消息
    @param command_id: 协议号
    @param dynamic_id: 动态ID
    #param request_proto: 消息体
    """

    argument = chat_pb2.ChatConectingRequest()
    argument.ParseFromString(request_proto)
    response = chat_pb2.ChatResponse()

    character_id = argument.owner.id
    character_nickname = argument.owner.nickname
    room_id = argument.channel
    content = argument.content
    to_character_id = argument.other.id
    to_character_nickname = argument.other.nickname

    info = localservice.callTarget(command_id, character_id, dynamic_id, room_id, content, character_nickname, \
                                   to_character_id, to_character_nickname)
    result = info.get('result', False)
    response.result = result
    return response.SerializeToString()

