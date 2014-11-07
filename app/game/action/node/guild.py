# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
from app.game.logic.guild import *
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def create_guild_801(dynamic_id, pro_data):
    """创建公会
    """
    return create_guild(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def join_guild_802(dynamic_id, pro_data):
    """加入公会
    """
    return join_guild(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def exit_guild_803(dynamic_id, pro_data):
    """退出公会
    """
    return exit_guild(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def editor_call_804(dynamic_id, pro_data):
    """编辑公告
    """
    return editor_call(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def deal_apply_805(dynamic_id, pro_data):
    """处理加入公会申请
    """
    return deal_apply(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def change_president_806(dynamic_id, pro_data):
    """转让会长
    """
    return change_president(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def kick_807(dynamic_id, pro_data):
    """踢人
    """
    return kick(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def promotion_808(dynamic_id, pro_data):
    """晋升
    """
    return promotion(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def worship_809(dynamic_id, pro_data):
    """膜拜
    """
    return worship(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def get_guild_rank_810(dynamic_id, pro_data):
    """获取公会排行
    """
    return get_guild_rank(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def get_role_list_811(dynamic_id, pro_data):
    """角色列表
    """
    return get_role_list(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def get_guild_info_812(dynamic_id, pro_data):
    """获取公会信息
    """
    return get_guild_info(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def get_apply_list_813(dynamic_id, pro_data):
    """获取申请列表
    """
    return get_apply_list(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def be_change_president_1801(dynamic_id, is_online):
    """获取申请列表
    """
    return be_change_president(dynamic_id, is_online)