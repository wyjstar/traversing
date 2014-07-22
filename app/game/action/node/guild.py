# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
from app.game.logic.guild import create_guild
from app.game.service.gatenoteservice import remote_service_handle


@remote_service_handle
def create_guild_801(dynamic_id, pro_data):
    """创建公会
    """
    print('cuick,AAAAAAAAAAAAAAAAA,01,node')
    return create_guild(dynamic_id, pro_data)


