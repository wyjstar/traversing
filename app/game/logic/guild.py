# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:37.
"""
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.common.check import have_player
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info, tb_guild_name
import time
from app.game.redis_mode import tb_character_guild
from app.game.action.root.netforwarding import get_guild_rank_from_gate, add_guild_to_rank, push_object, del_guild_room
from app.game.redis_mode import tb_character_info
from shared.db_opear.configs_data.game_configs import guild_config
from shared.db_opear.configs_data.game_configs import base_config
from app.game.action.root.netforwarding import login_guild_chat, logout_guild_chat
from shared.utils import trie_tree


@have_player
def create_guild(dynamicid, data, **kwargs):
    """
    创建公会
    """
    player = kwargs.get('player')
    args = CreateGuildRequest()
    args.ParseFromString(data)
    g_name = args.name
    response = GuildCommonResponse()
    p_id = player.base_info.id
    g_id = player.guild.g_id

    if base_config.get('create_level') > player.level.level:
        response.result = False
        response.message = "等级不够"
        return response.SerializeToString()

    if base_config.get('create_money') > player.finance.gold:
        response.result = False
        response.message = "元宝不足"
        return response.SerializeToString()

    if g_id != 0:
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()

    if trie_tree.check.replace_bad_word(g_name).encode("utf-8") != g_name:
        response.result = False
        response.message = "公会名不合法"
        return response.SerializeToString()

    if len(g_name) > 18:
        response.result = False
        response.message = "名称超过字数限制"
        return response.SerializeToString()

    # 判断有没有重名
    guild_name_data = tb_guild_name.getObjData(g_name)
    if guild_name_data:
        response.result = False
        response.message = "此名已存在"
        return response.SerializeToString()

    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, g_name)

    add_guild_to_rank(guild_obj.g_id, 1)

    data = {'g_name': g_name,
            'g_id': guild_obj.g_id}
    tb_guild_name.new(data)

    player.guild.g_id = guild_obj.g_id
    player.guild.worship = 0
    player.guild.worship_time = 1
    player.guild.contribution = 0
    player.guild.all_contribution = 0
    player.guild.k_num = 0
    player.guild.position = 1
    player.guild.save_data()
    guild_obj.save_data()
    player.finance.gold -= base_config.get('create_money')
    player.finance.save_data()

    # 加入公会聊天
    login_guild_chat(dynamicid, player.guild.g_id)

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
    response = JoinGuildResponse()
    g_id = args.g_id
    m_g_id = player.guild.g_id
    m_exit_time = player.guild.exit_time
    the_time = int(time.time())-m_exit_time

    if m_exit_time != 1 and the_time < base_config.get('exit_time'):
        response.result = False
        response.message = "退出公会办小时内不可加入公会"
        response.spare_time = base_config.get('exit_time') - the_time
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

    if guild_obj.get_p_num() >= guild_config.get(guild_obj.level).p_max:
        response.result = False
        response.message = "公会已满员"
        return response.SerializeToString()
    else:
        guild_obj.join_guild(p_id)
        guild_obj.save_data()

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
    if guild_obj.get_p_num() == 1:

        # 解散公会
        # 删除公会名字
        guild_name_data = tb_guild_name.getObjData(guild_obj.name)
        if guild_name_data:
            # guild_name_obj = tb_guild_name.getObj(guild_obj.name)
            # guild_name_obj.delete()
            tb_guild_name.deleteMode(guild_obj.name)

        # 解散公会，删除公会聊天室
        del_guild_room(player.guild.g_id)

        player.guild.g_id = 0
        player.guild.exit_time = int(time.time())
        player.guild.save_data()
        guild_obj.delete_guild()
        response.result = True
        response.message = "公会已解散"
        return response.SerializeToString()

    position = player.guild.position
    p_list = guild_obj.p_list
    position_p = p_list.get(position)

    if position_p.count(p_id) == 1:
        if position == 1:
            # 转让公会,并自己退出
            p_list = guild_obj.p_list
            guildinfolist = {}
            for num in range(2, 6):
                p_list1 = p_list.get(num)
                if p_list1:
                    for p_id1 in p_list1:
                        guildinfo = tb_character_guild.getObjData(p_id1)
                        if guildinfo:
                            guildinfolist.update({guildinfo.get('id'): guildinfo.get('info')})
            new_list = sorted(guildinfolist.items(), key=lambda x: (-1 * x[1]['position'], x[1]['contribution'],
                                                                    x[1]['k_num']), reverse=True)
            tihuan_id = new_list[0][0]
            tihuan_position = new_list[0][1].get('position')

            character_guild = tb_character_guild.getObjData(tihuan_id)
            info = character_guild.get("info")
            if info.get("g_id") != player.guild.g_id:
                response.result = False
                response.message = "此玩家不在公会"
                return response.SerializeToString()

            invitee_player = PlayersManager().get_player_by_id(tihuan_id)
            if invitee_player:  # 在线
                logout_guild_chat(invitee_player.dynamic_id)
                invitee_player.guild.position = 1
                invitee_player.guild.save_data()
            else:
                data = {
                    'info': {'g_id': info.get("g_id"),
                             'position': 1,
                             'contribution': info.get("contribution"),
                             'all_contribution': info.get("all_contribution"),
                             'k_num': info.get("k_num"),
                             'worship': info.get("worship"),
                             'worship_time': info.get("worship_time"),
                             'exit_time': info.get("exit_time")}}
                p_guild_data = tb_character_guild.getObj(tihuan_id)
                p_guild_data.update_multi(data)

            p_list1 = p_list.get(tihuan_position)
            p_list1.remove(tihuan_id)

            p_list.update({1: [tihuan_id], tihuan_position: p_list1})

            player.guild.g_id = 0
            player.guild.exit_time = int(time.time())
            player.guild.save_data()

            guild_obj.save_data()

            # 退出公会聊天
            logout_guild_chat(dynamicid)

            response.result = True
            response.message = "公会已转让，自己退出公会"
            return response.SerializeToString()
        player.guild.g_id = 0
        player.guild.exit_time = int(time.time())
        player.guild.save_data()
        guild_obj.exit_guild(p_id, position)
        guild_obj.save_data()
        # 退出公会聊天
        logout_guild_chat(dynamicid)
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
        response.result = True
        response.message = "公告内容超过字数限制"
        return response.SerializeToString()
    data1 = tb_guild_info.getObjData(player.guild.g_id)
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

        if call:
            call = trie_tree.check.replace_bad_word(call).encode("utf-8")

        guild_obj.editor_call(call)
        guild_obj.save_data()
        response.result = True
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
    response = DealApplyResponse()

    res_type = args.res_type
    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1 or m_g_id == 0:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    if res_type == 1:
        p_ids = args.p_ids

        if guild_obj.get_p_num()+len(p_ids) > guild_config.get(guild_obj.level).p_max:
            response.result = False
            response.message = "超出公会人数上限"
            return response.SerializeToString()

        for p_id in p_ids:
            character_guild = tb_character_guild.getObjData(p_id)
            info = character_guild.get("info")
            if info.get("g_id") != 0:
                if guild_obj.apply.count(p_id) == 1:
                    guild_obj.apply.remove(p_id)
                    response.p_ids.append(p_id)
                continue
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
                    p_list1 = guild_obj.p_list.get(5)
                    p_list1.append(p_id)
                    guild_obj.p_list.update({5: p_list1})
                else:
                    guild_obj.p_list.update({5: [p_id]})
                guild_obj.p_num += 1
            p_guild_data.update_multi(data)

            # 加入公会聊天室
            invitee_player = PlayersManager().get_player_by_id(p_id)
            if invitee_player:  # 在线
                login_guild_chat(invitee_player.dynamic_id, player.guild.g_id)
                invitee_player.guild.g_id = player.guild.g_id
                invitee_player.guild.save_data()

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
            # 判断玩家再不在线，在线直接通知，不在线的话发邮件。通知其他玩家

            character_guild = tb_character_guild.getObjData(p_p_id)
            info = character_guild.get("info")
            if info.get("g_id") != player.guild.g_id:
                response.result = False
                response.message = "此玩家不在公会"
                return response.SerializeToString()
            invitee_player = PlayersManager().get_player_by_id(p_p_id)
            if invitee_player:  # 在线
                logout_guild_chat(invitee_player.dynamic_id)
                invitee_player.guild.position = 1
                invitee_player.guild.save_data()
            else:
                data = {
                    'info': {'g_id': info.get("g_id"),
                             'position': 1,
                             'contribution': info.get("contribution"),
                             'all_contribution': info.get("all_contribution"),
                             'k_num': info.get("k_num"),
                             'worship': info.get("worship"),
                             'worship_time': info.get("worship_time"),
                             'exit_time': info.get("exit_time")}}
                p_guild_data = tb_character_guild.getObj(p_p_id)
                p_guild_data.update_multi(data)

            player.guild.position = 5
            player.guild.save_data()

            # 退出公会聊天
            logout_guild_chat(dynamicid)

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
                # TODO 踢人。判断目标玩家再不在线，发消息，通知
                character_guild = tb_character_guild.getObjData(p_id)
                info = character_guild.get("info")
                if info.get("g_id") == 0:
                    response.result = False
                    response.message = "此玩家不在公会"
                    return response.SerializeToString()
                data = {
                    'info': {'g_id': 0,
                             'position': 5,
                             'contribution': 0,
                             'all_contribution': 0,
                             'k_num': 0,
                             'worship': 0,
                             'worship_time': 1,
                             'exit_time': time.time()}}
                p_guild_data = tb_character_guild.getObj(p_id)
                p_guild_data.update_multi(data)

                # 踢出公会聊天室
                invitee_player = PlayersManager().get_player_by_id(p_id)
                if invitee_player:  # 在线
                    logout_guild_chat(invitee_player.dynamic_id)
                    invitee_player.guild.g_id = 0
                    invitee_player.guild.save_data()
                    push_object(814, args.SerializeToString(), [invitee_player.dynamic_id])

    response.result = True
    response.message = "踢人成功"
    return response.SerializeToString()


@have_player
def promotion(dynamicid, data, **kwargs):
    """
    晋升
    """
    player = kwargs.get('player')
    response = PromotionResponse()
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
    # 此职位还没有人
    if t_p_list and len(t_p_list) >= 1:
        list_len = len(t_p_list)
        t_position = m_position - 1
        flag = 0
        if t_position == 2:
            if list_len >= base_config.get('pos_p_num')[0]:
                flag = 1
        elif t_position == 3:
            if list_len >= base_config.get('pos_p_num')[1]:
                flag = 1
        elif t_position == 4:
            if list_len >= base_config.get('pos_p_num')[2]:
                flag = 1
        else:
            response.result = False
            response.message = "未知错误"
            return response.SerializeToString()
        # 此职位的人满了
        if flag == 1:
            guildinfolist = {}
            for p_id1 in t_p_list:
                guildinfo = tb_character_guild.getObjData(p_id1)
                if guildinfo:
                    guildinfolist.update({guildinfo.get('id'): guildinfo.get('info')})
            m_guildinfo = tb_character_guild.getObjData(m_p_id)
            guildinfolist.update({m_guildinfo.get('id'): m_guildinfo.get('info')})
            new_list = sorted(guildinfolist.items(), key=lambda x: (x[1]['contribution']), reverse=True)
            if new_list[-1][0] == m_p_id or new_list[-1][1].get('contribution') == new_list[-2][1].get('contribution'):
                response.result = False
                response.message = "总贡献必须超过上一级职位最低贡献才能晋级"
                return response.SerializeToString()

            tihuan_id = new_list[-1][0]
            # TODO 判断目标玩家再不在线，然后通知调换，修改数据，广播给公会其他人
            character_guild = tb_character_guild.getObjData(tihuan_id)
            info = character_guild.get("info")
            if info.get("g_id") != player.guild.g_id:
                response.result = False
                response.message = "未知错误"
                return response.SerializeToString()
            data = {
                'info': {'g_id': info.get("g_id"),
                         'position': m_position,
                         'contribution': info.get("contribution"),
                         'all_contribution': info.get("all_contribution"),
                         'k_num': info.get("k_num"),
                         'worship': info.get("worship"),
                         'worship_time': info.get("worship_time"),
                         'exit_time': info.get("exit_time")}}
            p_guild_data = tb_character_guild.getObj(tihuan_id)
            p_guild_data.update_multi(data)

            p_list1 = p_list.get(m_position)
            p_list1.remove(m_p_id)
            p_list1.append(tihuan_id)
            p_list2 = p_list.get(m_position - 1)
            p_list2.remove(tihuan_id)
            p_list2.append(m_p_id)
            response.p_id = tihuan_id
        else:  #此职位还没满
            p_list1 = p_list.get(m_position)
            p_list1.remove(m_p_id)
            p_list2 = p_list.get(m_position - 1)
            p_list2.append(m_p_id)
    else:
        p_list1 = p_list.get(m_position)
        p_list1.remove(m_p_id)
        p_list2 = [m_p_id]

    player.guild.position -= 1
    player.guild.save_data()

    p_list.update({m_position: p_list1, m_position - 1: p_list2})
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

    data1 = tb_guild_info.getObjData(m_g_id)
    if not data1 or m_g_id == 0:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()


    guild_obj = Guild()
    guild_obj.init_data(data1)

    # TODO 查询每天可以膜拜的次数.----玩家vip查询
    # 先判断是不是vip
    if 0:
        can_wopship = base_config.get('vip_worship_times') + base_config.get('worship_times')
    else:
        can_wopship = base_config.get('worship_times')

    # {膜拜编号：[资源类型,资源消耗量,获得公会经验,获得公会资金,获得个人贡献值]}
    worship_info = base_config.get('worship').get(unicode(w_type))

    if worship_info[1] == 1:  # 1金币  2元宝
        if worship_info[2] > player.finance.coin:
            response.result = False
            response.message = "金币不足"
            return response.SerializeToString()
    else:
        if worship_info[2] > player.finance.gold:
            response.result = False
            response.message = "元宝不足"
            return response.SerializeToString()

    if (int(time.time())-player.guild.worship_time) < (60*60*24):
        if can_wopship > player.guild.worship:
            player.guild.worship += 1
            player.guild.contribution += worship_info[4]
            player.guild.all_contribution += worship_info[3]
            guild_obj.fund += worship_info[3]
            guild_obj.exp += worship_info[2]
        else:
            response.result = False
            response.message = "今天的膜拜次数已用完"
            return response.SerializeToString()
    else:
        localtime = time.localtime(time.time())
        new_time = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', localtime), '%Y-%m-%d %H:%M:%S'))
        player.guild.worship += 1
        player.guild.contribution += worship_info[4]
        player.guild.all_contribution += worship_info[4]
        guild_obj.fund += worship_info[3]
        guild_obj.exp += worship_info[2]
        player.guild.worship_time = new_time

    if guild_obj.exp >= guild_config.get(guild_obj.level).exp:
        guild_obj.exp -= guild_config.get(guild_obj.level).exp
        guild_obj.level += 1
        add_guild_to_rank(guild_obj.g_id, guild_obj.level + (guild_obj.fund * 100))

    player.guild.save_data()
    guild_obj.save_data()

    # 根据膜拜类型判断减什么钱，然后扣除
    if worship_info[1] == 1:  # 1金币  2元宝
        player.finance.coin -= worship_info[2]
    else:
        player.finance.gold -= worship_info[2]
    player.finance.save_data()
    response.result = True
    response.message = "膜拜成功"
    return response.SerializeToString()


@have_player
def get_guild_rank(dynamicid, data, **kwargs):
    """
    获取公会排行列表
    """
    response = GuildRankProto()

    # 得到公会排行
    ranks = get_guild_rank_from_gate()
    rank_num = 1
    for rank in ranks:
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

            president_id = guild_obj.p_list.get(1)[0]
            player_data = tb_character_info.getObjData(president_id)
            if player_data:
                if player_data.get('nickname'):
                    guild_rank.president = player_data.get('nickname')
                else:
                    guild_rank.president = '无名'
            else:
                guild_rank.president = '错误'

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
    if guild_p_list.values():
        for p_list in guild_p_list.values():
            for role_id in p_list:
                character_guild = tb_character_guild.getObjData(role_id)
                character_info = tb_character_info.getObjData(role_id)
                if character_info and character_guild:
                    guild_info = character_guild.get("info")
                    role_info = response.role_info.add()
                    role_info.p_id = role_id

                    role_info.name = character_info['nickname']
                    role_info.level = character_info['level']

                    role_info.position = guild_info.get("position")
                    role_info.all_contribution = guild_info.get("all_contribution")
                    role_info.k_num = guild_info.get("k_num")

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
    guild_info.g_id = guild_obj.g_id
    guild_info.name = guild_obj.name
    guild_info.p_num = guild_obj.p_num
    guild_info.level = guild_obj.level
    guild_info.exp = guild_obj.exp
    guild_info.fund = guild_obj.fund
    guild_info.call = guild_obj.call
    guild_info.record = guild_obj.record
    guild_info.my_position = player.guild.position
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

    for role_id in guild_apply:
        # TODO 获取玩家 战斗力，vip等级
        character_info = tb_character_info.getObjData(role_id)
        if character_info:
            role_info = response.role_info.add()
            role_info.p_id = role_id
            if character_info['nickname']:
                role_info.name = character_info['nickname']
            else:
                role_info.name = '无名'
            role_info.level = character_info['level']
            role_info.vip_level = 1
            role_info.fight_power = 1

    response.result = True
    return response.SerializeToString()