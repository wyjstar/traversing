# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import CreateGuildRequest, CreateGuildResponse


# @have_player
def create_guild(dynamicid, data, **kwargs):
    """
    创建公会
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
    guild_obj = Guild(name)
    guild_obj.create_guild(p_id)
    guild_obj.save_data()
    guild_obj.init_data()

    # 返回
    response = CreateGuildResponse()
    res = response.res
    res.result = True
    print'cuick,AAAAAAAAAAAAAAAAAAAAA,02,logic,name:', name
    return response.SerializeToString()
