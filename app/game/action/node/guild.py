# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.guild import join_guild
from app.game.logic.guild import create_guild


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
