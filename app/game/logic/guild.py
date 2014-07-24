# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import CreateGuildRequest, CreateGuildResponse, \
    JoinGuildRequest, JoinGuildResponse
from app.game.redis_mode import tb_guild_info


# @have_player
def create_guild(dynamicid, data, **kwargs):
    """
    创建公会
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    args = CreateGuildRequest()
    args.ParseFromString(data)
    name = args.name
    # p_id = player.base_info.id
    p_id = 123456
    print'cuick,AAAAAAAAAAAAAAAAAAAAA,021,logic,p_id:', p_id
    # 判断name合法性，长度,敏感字过滤

    # 判断有没有重名

    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, name)
    guild_obj.save_data()

    # ==========TEST=============
    # 4baae030114d11e4aa29080027a4fa58
    # guild_obj = Guild()
    # data = tb_guild_info.getObjData('4baae030114d11e4aa29080027a4fa58')
    # guild_obj.init_data(data)
    # ===========================
    # 返回
    response = CreateGuildResponse()
    res = response.res
    res.result = True
    print'cuick,AAAAAAAAAAAAAAAAAAAAA,02,logic,name:', name
    return response.SerializeToString()


# @have_player
def join_guild(dynamicid, data, **kwargs):
    """
    加入公会
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    # p_id = player.base_info.id
    p_id = 123456
    args = JoinGuildRequest()
    args.ParseFromString(data)
    g_id = args.g_id
    print'cuick,BBBBBBBBBBBBBBBB,02,logic,join_guild,g_id:', g_id
    data1 = tb_guild_info.getObjData(g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)
    guild_obj.join_guild(p_id)
    guild_obj.save_data()
    # 返回
    response = JoinGuildResponse()
    res = response.res
    res.result = True
    print'cuick,AAAAAAAAAAAAAAAAAAAAA,02,logic,join_guild,name:', g_id
    return response.SerializeToString()