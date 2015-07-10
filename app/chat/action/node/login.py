# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午12:11.
"""
from app.chat.core.chat_room_manager import ChatRoomManager
from app.chat.core.chater_manager import ChaterManager
from app.chat.service.node.chatgateservice import nodeservice_handle


@nodeservice_handle
def login_chat_remote(dynamic_id, character_id, character_nickname, guild_id, gag_time):
    """登录聊天服务器
    @param dynamic_id: int 客户端的id
    @param character_id: int角色的id
    """
    character = ChaterManager().addchater_by_id(character_id)
    if character:
        ChaterManager().update_onland(character_id, dynamic_id, guild_id, gag_time)
        character.name = character_nickname
        character.guild_id = guild_id
        ChatRoomManager().join_room(dynamic_id, character.room_id)
        if guild_id != 0:
            ChatRoomManager().join_room(dynamic_id, character.guild_id)
    return True


@nodeservice_handle
def logout_chat_1003(dynamic_id):
    """登出聊天服务器
    @param dynamic_id:
    """
    character_id = ChaterManager().getid_by_dynamicid(dynamic_id)

    if not character_id:
        return False

    character = ChaterManager().getchater_by_id(character_id)
    if character:
        ChatRoomManager().leave_room(dynamic_id, character.room_id)
        ChatRoomManager().leave_room(dynamic_id, character.guild_id)
        ChaterManager().update_outland(character.character_id,
                                       dynamic_id,
                                       character.guild_id)

    return True


@nodeservice_handle
def login_guild_chat_remote(dynamic_id, guild_id):
    """加入公会房间
    """
    character_id = ChaterManager().getid_by_dynamicid(dynamic_id)

    if not character_id:
        return False

    character = ChaterManager().getchater_by_id(character_id)
    if character:
        character.guild_id = guild_id
        ChatRoomManager().join_room(dynamic_id, guild_id)
        ChaterManager().join_room(dynamic_id, guild_id)

    return True


@nodeservice_handle
def logout_guild_chat_remote(dynamic_id):
    """退出公会房间
    """
    character_id = ChaterManager().getid_by_dynamicid(dynamic_id)

    if not character_id:
        return False

    character = ChaterManager().getchater_by_id(character_id)
    if character:
        ChatRoomManager().leave_room(dynamic_id, character.guild_id)
        ChaterManager().leave_room(dynamic_id, character.guild_id)
        character.guild_id = 0

    return True


@nodeservice_handle
def del_guild_room_remote(guild_id):
    """退出公会房间
    """
    ids = ChaterManager().get_guild_dynamicid(guild_id)
    for dynamic_id in ids:

        character_id = ChaterManager().getid_by_dynamicid(dynamic_id)

        if not character_id:
            return False

        character = ChaterManager().getchater_by_id(character_id)
        if character:
            ChatRoomManager().leave_room(dynamic_id, character.guild_id)
            ChaterManager().leave_room(dynamic_id, character.guild_id)
            character.guild_id = 0

    return True
