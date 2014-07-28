# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import CreateGuildRequest, CreateGuildResponse, \
    JoinGuildRequest, JoinGuildResponse, ExitGuildRequest, ExitGuildResponse, \
    EditorCallRequest, EditorCallResponse
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
    g_id = player.guild.g_id
    print "cuick,###############,TEST,create_guild,g_id:", g_id
    if g_id != 0:
        res.result = False
        res.message = "您已加入公会"
        return response.SerializeToString()
    # TODO 判断name合法性，敏感字过滤
    if len(name) > 18:
        print "cuick,###############,TEST,create_guild:", name, 'call_len:', len(name)
        res.result = False
        res.message = "公告内容超过字数限制"
        return response.SerializeToString()
    # 判断有没有重名
    guild_name_data = tb_guild_name.getObjData(4)
    if guild_name_data:
        g_names = guild_name_data.get('info')
        if g_names.count(name) >= 1:
            res.result = False
            res.message = "此名已存在"
            return response.SerializeToString()
        else:
            g_names.append(name)
            guild_name_data1 = tb_guild_name.getObj(4)
            guild_name_data1.update_multi({'info': g_names})
    else:
            tb_guild_name.new({'id': 4, 'info': [name]})
    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, name)
    print 'cuick,test,guild_obj.get_g_id():', guild_obj.get_g_id()
    player.guild.g_id = guild_obj.get_g_id()
    player.guild.position = 1
    player.guild.save_data()
    guild_obj.save_data()
    res.result = True
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
    m_g_id = player.guild.g_id

    if m_g_id == g_id:
        res.result = False
        res.message = "您已加入此公会"
        return response.SerializeToString()

    if m_g_id != 0:
        res.result = False
        res.message = "您已加入公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(g_id)

    if not data1:
        res.result = False
        res.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    # TODO 根据公会等级得到公会人数上限，取配置
    if guild_obj.get_p_num() >= 30:
        res.result = False
        res.message = "公会已满员"
        return response.SerializeToString()
    else:
        guild_obj.join_guild(p_id)
        guild_obj.save_data()
    # 返回
    res.result = True
    return response.SerializeToString()


@have_player
def exit_guild(dynamicid, data, **kwargs):
    """
    退出公会
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = ExitGuildRequest()
    args.ParseFromString(data)
    response = ExitGuildResponse()
    res = response.res
    g_id = args.g_id
    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObjData(g_id)
    print "cuick,###############,TEST,data1:", data1
    if g_id == 0:
        res.result = False
        res.message = "您还未加入公会"
        return response.SerializeToString()
    if not data1 or m_g_id != g_id:
        res.result = False
        res.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    # 判断是否在公会，判断是否是会长，如果是会长，要转让。如果只有会长一个人，自动解散公会。
    if guild_obj.get_p_num() <= 1:
        print "cuick,###############,TEST,guild_obj.get_p_num():", guild_obj.get_p_num()
        # 解散公会
        # TODO 删除公会名字
        guild_obj.delete_guild()
        res.result = True
        res.message = "公会已解散"
        return response.SerializeToString()
    p_list = guild_obj.get_p_list()
    p_info = p_list.get(p_id)
    if p_info:
        if p_info.get('position') == 1:
            # 转让公会
            res.result = True
            res.message = "公会已转让"
            return response.SerializeToString()
        guild_obj.exit_guild(p_id)
        guild_obj.save_data()
        res.result = True
        return response.SerializeToString()
    res.result = False
    res.message = "您不在此公会"
    return response.SerializeToString()


@have_player
def editor_call(dynamicid, data, **kwargs):
    """
    编辑公告
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = EditorCallRequest()
    args.ParseFromString(data)
    response = EditorCallResponse()
    res = response.res
    g_id = args.g_id
    call = args.call
    if len(call) > 150:
        print "cuick,###############,TEST,call:", call, 'call_len:', len(call)
        res.result = True
        res.message = "公告内容超过字数限制"
        return response.SerializeToString()
    data1 = tb_guild_info.getObjData(g_id)
    print "cuick,###############,TEST,data1:", data1
    if not data1:
        res.result = False
        res.message = "公会ID错误"
        return response.SerializeToString()
    guild_obj = Guild()
    guild_obj.init_data(data1)
    p_list = guild_obj.get_p_list()
    p_info = p_list.get(p_id)
    if p_info:
        if p_info.get('position') > 2:
            res.result = True
            res.message = "权限不够"
            return response.SerializeToString()
        guild_obj.editor_call(call)
        guild_obj.save_data()
        res.result = True
        print "cuick,###############,TEST,call:", call, 'call_len:', len(call)
        return response.SerializeToString()
    else:
        res.result = False
        res.message = "您不在此公会"
        return response.SerializeToString()