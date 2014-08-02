# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info, tb_guild_name
import time
from app.game.redis_mode import tb_character_guild


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
    p_name = args.name
    response = GuildCommonResponse()
    p_id = player.base_info.id
    g_id = player.guild.g_id
    print "cuick,###############,TEST,create_guild,g_id:", g_id
    # TODO 判断等级够不够
    if g_id != 0:
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()
    # TODO 判断元宝数够不够
    # TODO 判断name合法性，敏感字过滤
    if len(p_name) > 18:
        print "cuick,###############,TEST,create_guild:", p_name, 'call_len:', len(p_name)
        response.result = False
        response.message = "公告内容超过字数限制"
        return response.SerializeToString()
    # 判断有没有重名
    guild_name_data = tb_guild_name.getObjData(1)
    if guild_name_data:
        g_names = guild_name_data.get('info')
        if g_names.count(p_name) >= 1:
            response.result = False
            response.message = "此名已存在"
            return response.SerializeToString()
        else:
            g_names.append(p_name)
            guild_name_data1 = tb_guild_name.getObj(1)
            guild_name_data1.update_multi({'info': g_names})
    else:
            tb_guild_name.new({'id': 1, 'info': [p_name]})
    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, p_name)
    print 'cuick,test,guild_obj.get_g_id():', guild_obj.get_g_id()
    player.guild.g_id = guild_obj.get_g_id()
    player.guild.position = 3
    player.guild.save_data()
    guild_obj.save_data()
    # TODO 扣除元宝
    response.result = True
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
    response = GuildCommonResponse()
    g_id = args.g_id
    m_g_id = player.guild.g_id
    m_exit_time = player.guild.exit_time
    if (int(time.time())-m_exit_time) <= (60*30):
        response.result = False
        response.message = "退出公会办小时内不可加入公会"
        return response.SerializeToString()
    if m_g_id != 0:
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(g_id)

    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    # TODO 根据公会等级得到公会人数上限，取配置
    if guild_obj.get_p_num() >= 30:
        response.result = False
        response.message = "公会已满员"
        return response.SerializeToString()
    else:
        guild_obj.join_guild(p_id)
        guild_obj.save_data()
    # 返回
    response.result = True
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
    response = GuildCommonResponse()
    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObjData(m_g_id)
    print "cuick,###############,TEST,guild_name_data:", tb_guild_name.getObjData(1)
    print "cuick,###############,TEST,data1:", data1, 'm_g_id:', m_g_id
    if m_g_id == 0:
        response.result = False
        response.message = "您还未加入公会"
        return response.SerializeToString()
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    # 判断是否在公会，判断是否是会长，如果是会长，要转让。如果只有会长一个人，自动解散公会。
    if guild_obj.get_p_num() <= 1:
        print "cuick,###############,TEST,guild_obj.get_p_num():", guild_obj.get_p_num()
        # 解散公会
        # 删除公会名字
        guild_name_data = tb_guild_name.getObjData(1)
        if guild_name_data:
            g_names = guild_name_data.get('info')
            g_names.remove(guild_obj.name)
            guild_name_data1 = tb_guild_name.getObj(1)
            guild_name_data1.update_multi({'info': g_names})
        player.guild._g_id = 0
        player.guild.exit_time = int(time.time())
        player.guild.save_data()
        guild_obj.delete_guild()
        response.result = True
        response.message = "公会已解散"
        return response.SerializeToString()
    position = player.guild.position
    p_list = guild_obj.p_list
    position_p = p_list.get(position)

    if position_p.count(p_id) >= 1:
        if position == 1:
            # 转让公会
            response.result = True
            response.message = "公会已转让"
            return response.SerializeToString()
        player.guild._g_id = 0
        player.guild.exit_time = time.time()
        player.guild.save_data()
        guild_obj.exit_guild(p_id, position)
        guild_obj.save_data()
        response.result = True
        return response.SerializeToString()

    response.result = False
    response.message = "您不在此公会"
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
    response = GuildCommonResponse()
    call = args.call
    if len(call) > 150:
        print "cuick,###############,TEST,call:", call, 'call_len:', len(call)
        response.result = True
        response.message = "公告内容超过字数限制"
        return response.SerializeToString()
    print player.guild.g_id, 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
    data1 = tb_guild_info.getObjData(player.guild.g_id)
    print "cuick,###############,TEST,data1:", data1
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()
    guild_obj = Guild()
    guild_obj.init_data(data1)

    position = player.guild.position
    p_list = guild_obj.p_list
    print position, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
    position_p_list = p_list.get(position)

    if position_p_list.count(p_id) >= 1:
        if position > 2:
            response.result = True
            response.message = "权限不够"
            return response.SerializeToString()
        guild_obj.editor_call(call)
        guild_obj.save_data()
        response.result = True
        print "cuick,###############,TEST,call:", call, 'call_len:', len(call)
        return response.SerializeToString()
    else:
        response.result = False
        response.message = "您不在此公会"
        return response.SerializeToString()


@have_player
def deal_apply(dynamicid, data, **kwargs):
    """
    处理加会申请
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = DealApplyRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_p_id = args.p_id
    p_type = args.type
    m_g_id = player.guild.g_id

    data1 = tb_guild_info.getObjData(m_g_id)

    if not data1 or m_g_id == 0:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()
    # TODO 判断申请者有没有公会
    # TODO 判断申请者上次离开公会时间。没有必要。。在玩家发申请的时候判断就好了
    guild_obj = Guild()
    guild_obj.init_data(data1)

    # TODO 根据公会等级得到公会人数上限，取配置
    if guild_obj.get_p_num() >= 30:
        response.result = False
        response.message = "公会已满员"
        return response.SerializeToString()
    # 处理玩家数据
    # 通过玩家id判断是否在线，如果在线，要通知玩家，并修改玩家数据，如果不在线，也要发邮件通知，直接修改redis，通知其他玩家
    # 处理公会这边数据
    if guild_obj.apply.count(p_p_id) >= 1:
        guild_obj.apply.remove(p_p_id)
        if p_type == 1:
            t_p_list = guild_obj.p_list
            t_p_list.update({5: guild_obj.p_list.get(5).append(p_p_id)})
            guild_obj.p_list = t_p_list
            guild_obj.p_num += 1
        guild_obj.save_data()
        response.result = True
        return response.SerializeToString()
    else:
        response.result = False
        response.message = "申请不存在"
        return response.SerializeToString()


@have_player
def change_president(dynamicid, data, **kwargs):
    """
    转让会长
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = ChangePresidentRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_p_id = args.p_id
    m_g_id = player.guild.g_id
    if player.guild.position != 1:
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)

    p_list = guild_obj.p_list()
    for num in range(2, 5):
        p_list1 = p_list.get(num)
        if p_list1.count(p_p_id) >= 1:
            p_list1.remove(p_p_id)
            p_list5 = p_list.get(5)
            p_list5.append(p_id)
            p_list.update({num: p_list1, 5: p_list5, 1: [p_p_id]})
            guild_obj.p_list = p_list
            guild_obj.save_data()
            # 修改目标玩家个人属性
            # 判断玩家再不在线，在线直接通知，不在线的话发邮件。通知其他玩家
            player.guild.position = 5
            player.guild.save_data()
            response.result = True
            response.message = "转让成功"
            return response.SerializeToString()
    # 没有找到此玩家
    response.result = False
    response.message = "玩家不在此公会"
    return response.SerializeToString()


@have_player
def kick(dynamicid, data, **kwargs):
    """
    踢出公会
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    args = KickRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_p_id = args.p_id
    m_g_id = player.guild.g_id
    if player.guild.position != 1:
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)

    p_list = guild_obj.p_list
    for num in range(2, 5):
        p_list1 = p_list.get(num)
        if p_list1.count(p_p_id) >= 1:
            p_list1.remove(p_p_id)
            p_list.update({num: p_list1})
            guild_obj.p_list = p_list
            guild_obj.p_num += 1
            guild_obj.save_data()
            # 判断目标玩家再不在线，发消息，通知，通知其他玩家
            response.result = True
            response.message = "转让成功"
            return response.SerializeToString()
    # 没有找到此玩家
    response.result = False
    response.message = "玩家不在此公会"
    return response.SerializeToString()


@have_player
def promotion(dynamicid, data, **kwargs):
    """
    晋升
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    response = GuildCommonResponse()
    m_g_id = player.guild.g_id
    m_p_id = player.base_info.id
    m_position = player.guild.position
    if m_position <= 2:
        response.result = False
        response.message = "您不能再晋升了"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)

    p_list = guild_obj.p_list
    t_p_list = p_list.get(m_position - 1)
    list_len = len(t_p_list)
    t_position = m_position - 1
    if t_position == 2:
        if list_len >= 2:
            response.result = False
            response.message = "上一级职位已满"
            return response.SerializeToString()
    elif t_position == 3:
        if list_len >= 3:
            response.result = False
            response.message = "上一级职位已满"
            return response.SerializeToString()
    else:
        if list_len >= 4:
            response.result = False
            response.message = "上一级职位已满"
            return response.SerializeToString()
    guildinfolist = {}
    for p_id1 in t_p_list:
        guildinfo = tb_character_guild.getObjData(p_id1)
        if guildinfo:
            guildinfolist.update(guildinfo)
    m_guildinfo = tb_character_guild.getObjData(m_p_id)
    guildinfolist.update(m_guildinfo)
    new_list = sorted(guildinfolist.items(), key=lambda x: (x[1]['contribution']), reverse=True)
    if new_list[-1][0] == m_p_id:
        response.result = False
        response.message = "总贡献必须超过上一级职位最低贡献才能晋级"
        return response.SerializeToString()
    # 和最后一个调换
    player.guild.position -= 1
    player.guild.save_data()
    tihuan_id = new_list[-1][0]
    # 判断目标玩家再不在线，然后通知调换，修改数据，广播给公会其他人
    p_list1 = p_list.get(m_position)
    p_list1.remove(m_p_id)
    p_list1.append(tihuan_id)
    tihuan_position = m_position - 1
    p_list2 = p_list.get(tihuan_position)
    p_list2.remove(tihuan_id)
    p_list2.append(m_p_id)
    p_list.update({m_position: p_list1, tihuan_position: p_list2})
    guild_obj.p_list = p_list
    guild_obj.save_data()
    response.result = True
    response.message = "晋升成功"
    return response.SerializeToString()


@have_player
def worship(dynamicid, data, **kwargs):
    """
    膜拜
    :param dynamicid:
    :param data:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')
    args = WorshipRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    # p_p_id = args.p_id
    m_g_id = player.guild.g_id
    m_p_id = player.base_info.id
    m_wopship = player.guild.worship

    m_wopship_time = player.guild.worship_time
    # TODO 查询每天可以膜拜的次数
    # TODO 判断钱够不够
    can_wopshiptimes = 5
    if (int(time.time())-m_wopship) < (60*60*24):
        if can_wopshiptimes > m_wopship_time:
            pass
            # mobai,膜拜次数+1
        else:
            response.result = False
            response.message = "今天的膜拜次数已用完"
            return response.SerializeToString()
    else:
        # 膜拜次数+1，时间改成今天
        pass

    # 膜拜：公会贡献+，玩家公会贡献+。膜拜次数+。膜拜时间更新。