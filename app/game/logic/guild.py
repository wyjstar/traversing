# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import CreateGuildRequest, CreateGuildResponse, \
    JoinGuildRequest, JoinGuildResponse
from app.game.redis_mode import tb_guild_info, tb_guild_name


@have_player
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
    response = CreateGuildResponse()
    res = response.res

    p_id = player.base_info.id
    # 判断name合法性，长度,敏感字过滤

    # 判断有没有重名
    guild_name_data = tb_guild_name.getObjData(4)
    if guild_name_data:
        g_names = guild_name_data.get('info')
        # print'cuick,AAAAAAAAAAAAAAAAAAAAA,021,logic,g_names:', g_names
        if g_names.count(name) >= 1:
            res.result = False
            res.message = u"此名称已存在"
            return response.SerializeToString()
        else:
            g_names.append(name)
            # print'cuick,AAAAAAAAAAAAAAAAAAAAA,022,logic,g_names:', g_names
            guild_name_data1 = tb_guild_name.getObj(4)
            guild_name_data1.update_multi({'info': g_names})
    else:
            tb_guild_name.new({'id': 4, 'info': [name]})
    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, name)
    guild_obj.save_data()
    res.result = True
    # print'cuick,AAAAAAAAAAAAAAAAAAAAA,02,logic,res:', res
    return response.SerializeToString()


@have_player
def join_guild(dynamicid, data, **kwargs):
    """
    加入公会
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = JoinGuildRequest()
    args.ParseFromString(data)
    response = JoinGuildResponse()
    res = response.res
    g_id = args.g_id
    data1 = tb_guild_info.getObjData(g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)
    if guild_obj.get_p_num() >= 20:
        res.result = False
        res.message = u"公会已满员"
        return response.SerializeToString()
    else:
        guild_obj.join_guild(p_id)
        guild_obj.save_data()
    # 返回
    res.result = True
    return response.SerializeToString()