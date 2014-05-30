#-*- coding:utf-8 -*-
"""
created by server on 14-5-20下午2:24.
"""
from app.chat.core.chater_manager import ChaterManager
from app.chat.core.chat_room_manager import ChatRoomManager
from app.chat.service.local.local_service import localservice_handle


@localservice_handle
def login_chat_1(command_id, character_id, dynamic_id, character_nickname):
    """登录聊天服务器
    @param dynamic_id: int 客户端的id
    @param character_id: int角色的id
    """
    character = ChaterManager().addchater_by_id(character_id)
    if character:
        ChaterManager().update_onland(character_id, dynamic_id)
        character.name = character_nickname
        ChatRoomManager().join_room(dynamic_id, character.room_id)
    return True


@localservice_handle
def logout_chat_3(command_id, dynamic_id):
    """登出聊天服务器
    @param command_id:
    @param dynamic_id:
    """
    character_id = ChaterManager().getid_by_dynamicid(dynamic_id)

    if not character_id:
        return False

    character = ChaterManager().getchater_by_id(character_id)
    if character:
        ChatRoomManager().leave_room(dynamic_id, character.room_id)
        ChaterManager().update_outland(character.character_id, dynamic_id)

    return True


