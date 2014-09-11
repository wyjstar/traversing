#-*- coding:utf-8 -*-
"""
created by server on 14-5-20下午8:33.
"""
from app.gate.service.local.gateservice import local_service_handle
from app.proto_file import chat_pb2
from gfirefly.server.globalobject import GlobalObject


@local_service_handle
def send_message_1002(command_id, dynamic_id, request_proto):
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
    guild_id = argument.guild_id

    info = GlobalObject().root.callChild('chat', command_id, character_id, dynamic_id, room_id, content, \
                                         character_nickname, to_character_id, to_character_nickname, guild_id)

    # info = localservice.callTarget(command_id, character_id, dynamic_id, room_id, content, character_nickname, \
    #                                to_character_id, to_character_nickname)
    result = info.get('result', False)
    response.result = result
    return response.SerializeToString()

