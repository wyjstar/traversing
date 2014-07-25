# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.guild import join_guild
from app.game.logic.guild import create_guild
from app.game.logic.guild import exit_guild
from app.game.logic.guild import editor_call


@remote_service_handle
def create_guild_801(dynamic_id, pro_data):
    """创建公会
    """
    print('cuick,AAAAAAAAAAAAAAAAA,01,node,create_guild_801')
    return create_guild(dynamic_id, pro_data)


@remote_service_handle
def join_guild_802(dynamic_id, pro_data):
    """加入公会
    """
    print('cuick,BBBBBBBBBBBBBBBBBB,01,node,join_guild_802')
    return join_guild(dynamic_id, pro_data)

@remote_service_handle
def exit_guild_803(dynamic_id, pro_data):
    """退出公会
    """
    print('cuick,CCCCCCCCCCCCCCCCCC,01,node,exit_guild_803')
    return exit_guild(dynamic_id, pro_data)

@remote_service_handle
def editor_call_804(dynamic_id, pro_data):
    """编辑公告
    """
    print('cuick,DDDDDDDDDDDDDDDDDDD,01,node,exit_guild_803')
    return editor_call(dynamic_id, pro_data)