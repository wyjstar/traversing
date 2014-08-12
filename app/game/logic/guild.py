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
from app.game.action.root.netforwarding import get_guild_rank_from_gate, add_guild_to_rank


@have_player
def create_guild(dynamicid, data, **kwargs):
    """
    创建公会
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
    print 'cuick,test,guild_obj.g_id():', guild_obj.g_id
    player.guild.g_id = guild_obj.g_id

    add_guild_to_rank(guild_obj.g_id)

    player.guild.position = 1
    player.guild.save_data()
    guild_obj.save_data()
    # TODO 扣除元宝
    response.result = True
    return response.SerializeToString()


@have_player
def join_guild(dynamicid, data, **kwargs):
    """
    加入公会
    """
    player = kwargs.get('player')
    p_id = player.base_info.id
    args = JoinGuildRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    g_id = args.g_id
    m_g_id = player.guild.g_id
    m_exit_time = player.guild.exit_time
    print 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb', m_exit_time
    if m_exit_time != 1 and (int(time.time())-m_exit_time) < (60*30):
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
    # TODO 过滤敏感词语
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
    """
    player = kwargs.get('player')
    args = DealApplyRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()

    res_type = args.res_type
    m_g_id = player.guild.g_id
    print 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaap_ids', args.p_ids, 'bbbbbbbbbbbbbres_bype', res_type
    data1 = tb_guild_info.getObjData(m_g_id)
    print 'eeeeeeeeeeeeeee', data1, 'ffffffffff', m_g_id
    if not data1 or m_g_id == 0:
        print 'gggggggggggggggggggggggggggg'
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    print 'hhhhhhhhhhhhhhhhhh', res_type, 'iiiiiiii', args.p_ids
    if res_type == 1:
        # TODO 根据公会等级得到公会人数上限，取配置
        p_ids = args.p_ids

        if guild_obj.get_p_num()+len(p_ids) > 30:
            print 'cccccccccccccccccccccc', guild_obj.get_p_num(), 'ddddd', len(p_ids)
            response.result = False
            response.message = "超出公会人数上限"
            return response.SerializeToString()

        for p_id in p_ids:
            # TODO 判断申请者有没有公会
            character_guild = tb_character_guild.getObjData(p_id)
            info = character_guild.get("info")
            if info.get("g_id") != 0:
                response.result = False
                response.message = "次玩家已有公会"
                return response.SerializeToString()
            data = {
            'info': {'g_id': player.guild.g_id,
                     'position': 5,
                     'contribution': 0,
                     'all_contribution': 0,
                     'k_num': 0,
                     'worship': 0,
                     'worship_time': 1,
                     'exit_time': 1}}
            p_guild_data = tb_character_guild.getObj(p_id)
            if guild_obj.apply.count(p_id) == 1:
                guild_obj.apply.remove(p_id)
                if guild_obj.p_list.get(5):
                    guild_obj.p_list.update({5: guild_obj.p_list.get(5).append(p_id)})
                guild_obj.p_list.update({5: [p_id]})
                guild_obj.p_num += 1
            p_guild_data.update_multi(data)

    elif res_type == 2:
        p_ids = args.p_ids
        for p_id in p_ids:
            if guild_obj.apply.count(p_id) == 1:
                guild_obj.apply.remove(p_id)

    else:  # res_type == 3
        guild_obj.apply = []

    guild_obj.save_data()
    response.result = True
    response.message = "处理成功"
    return response.SerializeToString()


@have_player
def change_president(dynamicid, data, **kwargs):
    """
    转让会长
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

    p_list = guild_obj.p_list
    for num in range(2, 6):
        p_list1 = p_list.get(num)
        if p_list1 and p_list1.count(p_p_id) >= 1:
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
    """
    player = kwargs.get('player')
    args = KickRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_ids = args.p_ids
    m_g_id = player.guild.g_id
    if player.guild.position != 1:
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()
    data1 = tb_guild_info.getObjData(m_g_id)
    guild_obj = Guild()
    guild_obj.init_data(data1)
    p_list = guild_obj.p_list
    for p_id in p_ids:
        for num in range(2, 6):
            p_list1 = p_list.get(num)
            if p_list1 and p_list1.count(p_id) == 1:
                p_list1.remove(p_id)
                p_list.update({num: p_list1})
                guild_obj.p_list = p_list
                guild_obj.p_num -= 1
                guild_obj.save_data()
                # 判断目标玩家再不在线，发消息，通知
    response.result = True
    response.message = "踢人成功"
    return response.SerializeToString()


@have_player
def promotion(dynamicid, data, **kwargs):
    """
    晋升
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
    # TODO 判断目标玩家再不在线，然后通知调换，修改数据，广播给公会其他人
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
    """
    player = kwargs.get('player')
    args = WorshipRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    w_type = args.w_type
    m_g_id = player.guild.g_id
    m_wopship = player.guild.worship

    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1 or m_g_id == 0:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    m_wopship_time = player.guild.worship_time
    # TODO 查询每天可以膜拜的次数
    # TODO 判断钱够不够,根据膜拜类型
    # TODO 根据膜拜类型，加资源数，经验数不同。
    can_wopship = 5
    if (int(time.time())-m_wopship_time) < (60*60*24):
        if can_wopship > m_wopship:
            player.guild.worship += 1
            player.guild.contribution += 100
            player.guild.all_contribution += 100  # 配置
            guild_obj.fund += 100  # 公会加经验，加资金，
            guild_obj.exp += 100
        else:
            response.result = False
            response.message = "今天的膜拜次数已用完"
            return response.SerializeToString()
    else:
        localtime = time.localtime(time.time())
        new_time = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', localtime), '%Y-%m-%d %H:%M:%S'))
        player.guild.worship += 1
        player.guild.contribution += 100
        player.guild.all_contribution += 100  # 配置
        guild_obj.fund += 100  # 公会加经验，加资金，
        guild_obj.exp += 100
        player.guild.wopship_time = new_time
    # TODO 判断公会经验有没有升级！！！！！！！！！！
    print player.guild.contribution,'aaa',guild_obj.fund,'bbbb',guild_obj.exp
    player.guild.save_data()
    guild_obj.save_data()
    # 膜拜：公会贡献+，玩家公会贡献+。膜拜次数+。膜拜时间更新。公会资金+，公会经验+
    response.result = True
    response.message = "膜拜成功"
    return response.SerializeToString()


@have_player
def get_guild_rank(dynamicid, data, **kwargs):
    """
    获取公会排行列表
    """
    response = GuildRankProto()
    # TODO 得到公会排行，g-id-list
    ranks = get_guild_rank_from_gate()
    print 'cuick,create_guild,gate_res,BBBBBBBBBBBB,:', ranks
    # guild_rank_list = ['123', '456', '789' '111', '222', '333']
    rank_num = 1
    for rank in ranks:
        # TODO 获取公会的：排名，名称，等级，会长，人数，战绩
        data1 = tb_guild_info.getObjData(rank[0])
        if data1 and rank != 0:
            guild_obj = Guild()
            guild_obj.init_data(data1)
            guild_rank = response.guild_rank.add()
            guild_rank.g_id = guild_obj.g_id
            guild_rank.rank = rank_num
            rank_num += 1
            guild_rank.name = guild_obj.name
            guild_rank.level = guild_obj.level
            guild_rank.president = 'huizhangname'
            guild_rank.p_num = guild_obj.p_num
            guild_rank.record = guild_obj.record

    response.result = True
    return response.SerializeToString()


@have_player
def get_role_list(dynamicid, data, **kwargs):
    """
    获取公会玩家列表
    """
    response = GuildRoleListProto()
    player = kwargs.get('player')
    m_g_id = player.guild.g_id
    if m_g_id == 0:
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_p_list = guild_obj.p_list
    # guild_p_list = {1: [12, 23, 34, 45], 2: [23, 34, 45], 3: [56, 67, 78]}
    for p_list in guild_p_list.values():
        for role_id in p_list:
            role_info = response.role_info.add()
            role_info.p_id = role_id
            # TODO 获取名称,等级，职位，总贡献，杀敌
            character_guild = tb_character_guild.getObjData(role_id)
            info = character_guild.get("info")

            role_info.name = 'name'
            role_info.level = 1
            role_info.position = info.get("position")
            role_info.all_contribution = info.get("all_contribution")
            role_info.k_num = info.get("k_num")
    response.result = True
    return response.SerializeToString()


@have_player
def get_guild_info(dynamicid, data, **kwargs):
    """
    获取公会信息
    """
    response = GuildInfoProto()
    player = kwargs.get('player')
    m_g_id = player.guild.g_id
    if m_g_id == 0:
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    response.result = True
    guild_info = response.guild_info
    print 'cuick,Test##################,G ID :', guild_obj.g_id
    guild_info.g_id = guild_obj.g_id
    guild_info.name = guild_obj.name
    guild_info.p_num = guild_obj.p_num
    guild_info.level = guild_obj.level
    guild_info.exp = guild_obj.exp
    guild_info.fund = guild_obj.fund
    guild_info.call = guild_obj.call
    guild_info.record = guild_obj.record
    return response.SerializeToString()


@have_player
def get_apply_list(dynamicid, data, **kwargs):
    """
    获取申请列表
    """
    response = ApplyListProto()
    player = kwargs.get('player')
    m_g_id = player.guild.g_id
    if m_g_id == 0:
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_apply = guild_obj.apply
    # guild_apply = [123, 456, 11, 22, 33, 44, 55, 66, 77, 88, 99]
    for role_id in guild_apply:
        # TODO 获取玩家name，等级，战斗力，vip等级
        role_info = response.role_info.add()
        role_info.p_id = role_id
        role_info.name = 'name'
        role_info.level = 1
        role_info.vip_level = 1
        role_info.fight_power = 1

    response.result = True
    return response.SerializeToString()