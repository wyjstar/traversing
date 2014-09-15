# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午8:33.
"""
from app.chat.core.chater_manager import ChaterManager
from app.chat.service.node.chatgateservice import nodeservice_handle
from app.proto_file import chat_pb2
from app.chat.service.node.chatgateservice import noderemote


@nodeservice_handle
def send_message_1002(command_id, character_id, dynamic_id, room_id, content, character_nickname, \
                      to_character_id, to_character_nickname, guild_id):
    """发送信息
    @param character_nickname: 角色昵称
    @param to_character_id: 私聊对象角色id
    @param to_character_nickname: 私聊对象角色昵称
    @param dynamic_id: int 客户端的id
    @param character_id: int角色的id
    @param room_id: int 聊天频道
    @param content: str 聊天内容
    @param command_id: 协议编号
    """
    chater = ChaterManager().getchater_by_id(character_id)
    ids = []
    ids = ChaterManager().getall_dynamicid()
    if not chater:
        # TODO message 信息要补充
        return {'result': False}

    if room_id == 1:  # 世界聊天频道
        ids = ChaterManager().getall_dynamicid()
        response = chat_pb2.chatMessageResponse()
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        response.content = content
        noderemote.callRemoteNotForResult('push_chat_message', ids, response.SerializeToString())

    elif room_id == 3:  # 私聊频道
        other_chater = ChaterManager().getchater_by_id(to_character_id)
        if not other_chater:
            return {'result': False}
        response = chat_pb2.chatMessageResponse()
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        response.content = content
        noderemote.callRemoteNotForResult('push_chat_message', [other_chater.dynamic_id], response.SerializeToString())

    elif room_id == 2:  # 公会频道
        ids = ChaterManager().get_guild_dynamicid(guild_id)
        response = chat_pb2.chatMessageResponse()
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        response.content = content
        noderemote.callRemoteNotForResult('push_chat_message', ids, response.SerializeToString())

    return {'result': True}
