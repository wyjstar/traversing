# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:50.
"""
import re
import cPickle
import time
from app.game.core.PlayersManager import PlayersManager
from app.game.core.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info, tb_guild_name
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
from shared.utils import trie_tree
from shared.tlog import tlog_action
from app.proto_file.db_pb2 import Mail_PB
from app.game.component.mail.mail import MailComponent
from app.game.action.root import netforwarding


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def create_guild_801(data, player):
    """创建公会 """
    args = CreateGuildRequest()
    args.ParseFromString(data)
    g_name = args.name
    response = GuildCommonResponse()
    p_id = player.base_info.id
    g_id = player.guild.g_id

    if game_configs.base_config.get('create_level') > player.base_info.level:
        response.result = False
        response.message = "等级不够"
        return response.SerializeToString()

    if game_configs.base_config.get('create_money') > player.finance.gold:
        response.result = False
        response.message = "元宝不足"
        return response.SerializeToString()

    if g_id != 'no':
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()

    if not g_name:
        response.result = False
        response.message = "公会名不能为空"
        return response.SerializeToString()

    match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', unicode(g_name, "utf-8"))
    if match:
        response.result = False
        response.message = "公会名不合法"
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
    guild_name_data = tb_guild_name.getObj('names')
    _result =  guild_name_data.hsetnx(g_name, '')
    if not _result:
        response.result = False
        response.message = "此名已存在"
        return response.SerializeToString()

    # 创建公会
    guild_obj = Guild()
    guild_obj.create_guild(p_id, g_name)

    guild_name_data.hmset({g_name: guild_obj.g_id})
    remote_gate.add_guild_to_rank_remote(guild_obj.g_id, 1)

    player.guild.g_id = guild_obj.g_id
    player.guild.worship = 0
    player.guild.worship_time = 1
    player.guild.contribution = 0
    player.guild.all_contribution = 0
    player.guild.k_num = 0
    player.guild.position = 1
    player.guild.save_data()
    guild_obj.save_data()
    player.finance.consume_gold(game_configs.base_config.get('create_money'))
    player.finance.save_data()

    # 加入公会聊天
    remote_gate.login_guild_chat_remote(player.dynamic_id, player.guild.g_id)

    response.result = True
    tlog_action.log('CreatGuild', player, player.guild.g_id, player.base_info.level)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def join_guild_802(data, player):
    """加入公会 """
    p_id = player.base_info.id
    args = JoinGuildRequest()
    args.ParseFromString(data)
    response = JoinGuildResponse()
    g_id = args.g_id
    m_g_id = player.guild.g_id
    m_exit_time = player.guild.exit_time
    the_time = int(time.time())-m_exit_time

    if m_exit_time != 1 and the_time < game_configs.base_config.get('exit_time'):
        response.result = False
        response.message = "退出公会半小时内不可加入公会"
        response.spare_time = game_configs.base_config.get('exit_time') - the_time
        return response.SerializeToString()

    open_stage_id = game_configs.base_config.get('guildOpenStage')
    if player.stage_component.get_stage(open_stage_id).state == -2:
        response.result = False
        response.message = "未完成指定关卡"
        # response.result_no = 837
        return response.SerializeToString()

    if m_g_id != 'no':
        response.result = False
        response.message = "您已加入公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(g_id).hgetall()

    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    p_list = guild_obj.p_list
    captain_id = p_list.get(1)[0]

    if guild_obj.get_p_num() >= game_configs.guild_config.get(guild_obj.level).p_max:
        response.result = False
        response.message = "公会已满员"
        return response.SerializeToString()
    else:
        invitee_player = PlayersManager().get_player_by_id(captain_id)
        if invitee_player:  # 在线
            remote_gate.push_object_remote(850,
                                           u'',
                                           [invitee_player.dynamic_id])
        else:
            remote_gate.is_online_remote('modify_user_guild_info_remote', captain_id, {'cmd': 'join_guild'})

        guild_obj.join_guild(p_id)
        guild_obj.save_data()

    response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def exit_guild_803(data, player):
    """退出公会 """
    p_id = player.base_info.id
    dynamicid = player.dynamic_id
    response = GuildCommonResponse()
    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()

    if m_g_id == 'no':
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
        guild_name_data = tb_guild_name.getObj('names')
        if guild_name_data.hexists(guild_obj.name):
            guild_name_data.hdel(guild_obj.name)

        # 解散公会，删除公会聊天室
        remote_gate.del_guild_room_remote(player.guild.g_id)

        player.guild.g_id = 'no'
        player.guild.exit_time = int(time.time())
        player.guild.save_data()
        guild_obj.delete_guild()
        response.result = True
        response.message = "公会已解散"
        tlog_action.log('ExitGuild', player, m_g_id)
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
                        guildinfo = tb_character_info.getObj(p_id1).hgetall()
                        if guildinfo:
                            guildinfolist.update({guildinfo.get('id'): guildinfo})
            new_list = sorted(guildinfolist.items(), key=lambda x: (-1 * x[1]['position'], x[1]['contribution'],
                                                                    x[1]['k_num']), reverse=True)
            tihuan_id = new_list[0][0]
            tihuan_position = new_list[0][1].get('position')

            info = tb_character_info.getObj(tihuan_id).hgetall()
            if info.get("guild_id") != player.guild.g_id:
                response.result = False
                response.message = "此玩家不在公会"
                return response.SerializeToString()

            invitee_player = PlayersManager().get_player_by_id(tihuan_id)
            if invitee_player:  # 在线
                invitee_player.guild.position = 1
                invitee_player.guild.save_data()
            else:
                data = {'guild_id': info.get("guild_id"),
                        'position': 1,
                        'contribution': info.get("contribution"),
                        'all_contribution': info.get("all_contribution"),
                        'k_num': info.get("k_num"),
                        'worship': info.get("worship"),
                        'worship_time': info.get("worship_time"),
                        'exit_time': info.get("exit_time")}
                is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', tihuan_id, {'cmd': 'exit_guild', 'position': 1})
                if is_online == "notonline":
                    p_guild_data = tb_character_info.getObj(tihuan_id)
                    p_guild_data.hmset(data)

            # if not push_message(1801, tihuan_id):
            #     response.result = False
            #     response.message = '系统错误'
            #     return response.SerializePartialToString()  # fail

            p_list1 = p_list.get(tihuan_position)
            p_list1.remove(tihuan_id)

            player.guild.g_id = 'no'
            player.guild.exit_time = int(time.time())
            player.guild.save_data()

            guild_obj.p_list.update({1: [tihuan_id], tihuan_position: p_list1})
            guild_obj.p_num -= 1
            guild_obj.save_data()

            # 退出公会聊天
            remote_gate.logout_guild_chat_remote(dynamicid)

            response.result = True
            tlog_action.log('GuildChangePresident', player, m_g_id, tihuan_id)
            tlog_action.log('ExitGuild', player, m_g_id)
            response.message = "公会已转让，自己退出公会"
            return response.SerializeToString()
        player.guild.g_id = 'no'
        player.guild.exit_time = int(time.time())
        player.guild.save_data()
        guild_obj.exit_guild(p_id, position)
        guild_obj.save_data()
        # 退出公会聊天
        remote_gate.logout_guild_chat_remote(dynamicid)
        response.result = True
        tlog_action.log('ExitGuild', player, m_g_id)
        return response.SerializeToString()
    response.result = False
    response.message = "您不在此公会"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def modify_user_guild_info_remote(data, player):
    if data['cmd'] == 'change_president':
        player.guild.position = data['position']
        player.guild.save_data()
    elif data['cmd'] == 'exit_guild':
        player.guild.position = data['position']
        player.guild.save_data()
    elif data['cmd'] == 'deal_apply':
        remote_gate.login_guild_chat_remote(player.dynamic_id,
                                            data['guild_id'])
        player.guild.g_id = data['guild_id']
        player.guild.position = 5
        player.guild.contribution = 0
        player.guild.all_contribution = 0
        player.guild.k_num = 0
        player.guild.exit_time = 1
        player.guild.save_data()
    elif data['cmd'] == 'kick':
        remote_gate.logout_guild_chat_remote(player.dynamic_id)
        player.guild.g_id = 'no'
        player.guild.save_data()
        remote_gate.push_object_remote(814,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'join_guild':
        remote_gate.push_object_remote(850,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'promotion':
        player.guild.position = data['position']
        player.guild.save_data()
    return True


@remoteserviceHandle('gate')
def editor_call_804(data, player):
    """编辑公告 """
    p_id = player.base_info.id
    args = EditorCallRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    call = args.call
    if len(call) > 150:
        response.result = True
        response.message = "公告内容超过字数限制"
        return response.SerializeToString()
    data1 = tb_guild_info.getObj(player.guild.g_id).hgetall()
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


@remoteserviceHandle('gate')
def deal_apply_805(data, player):
    """处理加入公会申请 """
    args = DealApplyRequest()
    args.ParseFromString(data)
    response = DealApplyResponse()

    res_type = args.res_type
    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 'no':
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    if res_type == 1:
        p_ids = args.p_ids

        if guild_obj.get_p_num()+len(p_ids) > game_configs.guild_config.get(guild_obj.level).p_max:
            response.result = False
            response.message = "超出公会人数上限"
            return response.SerializeToString()

        for p_id in p_ids:
            info = tb_character_info.getObj(p_id).hget('guild_id')
            if info != 'no':
                if guild_obj.apply.count(p_id) == 1:
                    guild_obj.apply.remove(p_id)
                    response.p_ids.append(p_id)
                continue
            # 加入公会聊天室
            invitee_player = PlayersManager().get_player_by_id(p_id)
            if invitee_player:  # 在线
                remote_gate.login_guild_chat_remote(invitee_player.dynamic_id,
                                                    invitee_player.guild.g_id)
                invitee_player.guild.g_id = player.guild.g_id
                invitee_player.guild.position = 5
                invitee_player.guild.contribution = 0
                invitee_player.guild.all_contribution = 0
                invitee_player.guild.k_num = 0
                # invitee_player.guild.worship = 0
                # invitee_player.guild.worship_time = 1
                invitee_player.guild.exit_time = 1
                invitee_player.guild.save_data()
            else:
                data = {'guild_id': player.guild.g_id,
                        'position': 5,
                        'contribution': 0,
                        'all_contribution': 0,
                        'k_num': 0,
                        # 'worship': 0,
                        # 'worship_time': 1,
                        'exit_time': 1}
                is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', p_id, {'cmd': 'deal_apply', "guild_id": player.guild.g_id})
                if is_online == "notonline":
                    p_guild_data = tb_character_info.getObj(p_id)
                    p_guild_data.hmset(data)

            if guild_obj.apply.count(p_id) == 1:
                guild_obj.apply.remove(p_id)
                if guild_obj.p_list.get(5):
                    p_list1 = guild_obj.p_list.get(5)
                    p_list1.append(p_id)
                    guild_obj.p_list.update({5: p_list1})
                else:
                    guild_obj.p_list.update({5: [p_id]})
                guild_obj.p_num += 1
                tlog_action.log('DealJoinGuild', player, m_g_id,
                                p_id, 1)

    elif res_type == 2:
        p_ids = args.p_ids
        for p_id in p_ids:
            if guild_obj.apply.count(p_id) == 1:
                guild_obj.apply.remove(p_id)
            tlog_action.log('DealJoinGuild', player, m_g_id,
                            p_id, 2)

    else:  # res_type == 3
        guild_obj.apply = []
        tlog_action.log('DealJoinGuild', player, m_g_id,
                        '', 3)

    guild_obj.save_data()
    response.result = True
    response.message = "处理成功"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def change_president_806(data, player):
    """转让会长 """
    dynamicid = player.dynamic_id
    p_id = player.base_info.id
    args = ChangePresidentRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_p_id = args.p_id
    m_g_id = player.guild.g_id
    if player.guild.position != 1:
        logger.debug('guild change president : you are`t president')
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
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

            info = tb_character_info.getObj(p_p_id).hgetall()
            if info.get("guild_id") != player.guild.g_id:
                logger.debug('guild change president : player don`t in guild')
                response.result = False
                response.message = "此玩家不在公会"
                return response.SerializeToString()
            invitee_player = PlayersManager().get_player_by_id(p_p_id)
            if invitee_player:  # 在线
                invitee_player.guild.position = 1
                invitee_player.guild.save_data()
            else:
                data = {'position': 1}
                is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', p_p_id, {'cmd': 'change_president', 'position': 1})
                if is_online == "notonline":
                    p_guild_data = tb_character_info.getObj(p_p_id)
                    p_guild_data.hmset(data)

            player.guild.position = 5
            player.guild.save_data()

            # 退出公会聊天
            # remote_gate.logout_guild_chat_remote(dynamicid)

            response.result = True
            response.message = "转让成功"
            tlog_action.log('GuildChangePresident', player, m_g_id, p_p_id)
            return response.SerializeToString()
    # 没有找到此玩家
    logger.debug('guild change president : dont find player')
    response.result = False
    response.message = "玩家不在此公会"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kick_807(data, player):
    """踢人 """
    args = KickRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    p_ids = args.p_ids
    m_g_id = player.guild.g_id
    if player.guild.position != 1:
        logger.debug('guild kick:you are not position:%s', player.guild.position)
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
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
                guild_id_info = tb_character_info.getObj(p_id).hget('guild_id')
                if guild_id_info == 'no':
                    response.result = False
                    response.message = "此玩家不在公会"
                    return response.SerializeToString()
                # 踢出公会聊天室
                invitee_player = PlayersManager().get_player_by_id(p_id)
                tlog_action.log('GuildKick', player, m_g_id, p_id)
                if invitee_player:  # 在线
                    remote_gate.logout_guild_chat_remote(invitee_player.dynamic_id)
                    invitee_player.guild.g_id = 'no'
                    invitee_player.guild.save_data()
                    remote_gate.push_object_remote(814,
                                                   u'',
                                                   [invitee_player.dynamic_id])
                else:
                    data = {'guild_id': 'no',
                            'position': 5,
                            'contribution': 0,
                            'all_contribution': 0,
                            'k_num': 0,
                            # 'worship': 0,
                            # 'worship_time': 1,
                            'exit_time': int(time.time())}
                    is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', p_id, {'cmd': 'kick'})
                    if is_online == "notonline":
                        p_guild_data = tb_character_info.getObj(p_id)
                        p_guild_data.hmset(data)

    response.result = True
    response.message = "踢人成功"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def promotion_808(data, player):
    """晋升 """
    response = PromotionResponse()
    m_g_id = player.guild.g_id
    m_p_id = player.base_info.id
    m_position = player.guild.position
    tihuan_id = 0
    if m_position <= 2:
        response.result = False
        response.message = "您不能再晋升了"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
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
            if list_len >= game_configs.base_config.get('pos_p_num')[0]:
                flag = 1
        elif t_position == 3:
            if list_len >= game_configs.base_config.get('pos_p_num')[1]:
                flag = 1
        elif t_position == 4:
            if list_len >= game_configs.base_config.get('pos_p_num')[2]:
                flag = 1
        else:
            response.result = False
            response.message = "未知错误"
            return response.SerializeToString()
        # 此职位的人满了
        if flag == 1:
            guildinfolist = {}
            for p_id1 in t_p_list:
                guildinfo = tb_character_info.getObj(p_id1).hgetall()
                if guildinfo:
                    guildinfolist.update({guildinfo.get('id'): guildinfo})
            m_guildinfo = tb_character_info.getObj(m_p_id).hgetall()
            guildinfolist.update({m_guildinfo.get('id'): m_guildinfo})
            new_list = sorted(guildinfolist.items(), key=lambda x: (x[1]['contribution']), reverse=True)
            if new_list[-1][0] == m_p_id or new_list[-1][1].get('contribution') == new_list[-2][1].get('contribution'):
                response.result = False
                response.message = "总贡献必须超过上一级职位最低贡献才能晋级"
                return response.SerializeToString()

            tihuan_id = new_list[-1][0]
            info = tb_character_info.getObj(tihuan_id).hgetall()
            if info.get("guild_id") != player.guild.g_id:
                response.result = False
                response.message = "未知错误"
                return response.SerializeToString()
            invitee_player = PlayersManager().get_player_by_id(tihuan_id)
            if invitee_player:  # 在线
                invitee_player.guild.position = m_position
                invitee_player.guild.save_data()
            else:
                data = {'guild_id': info.get("guild_id"),
                        'position': m_position,
                        'contribution': info.get("contribution"),
                        'all_contribution': info.get("all_contribution"),
                        'k_num': info.get("k_num"),
                        'worship': info.get("worship"),
                        'worship_time': info.get("worship_time"),
                        'exit_time': info.get("exit_time")}

                is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', tihuan_id, {'cmd': 'promotion', 'position': m_position})
                if is_online == "notonline":
                    p_guild_data = tb_character_info.getObj(tihuan_id)
                    p_guild_data.hmset(data)

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
    tlog_action.log('GuildPromotion', player, m_g_id, tihuan_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def worship_809(data, player):
    """膜拜 """
    args = WorshipRequest()
    args.ParseFromString(data)
    response = GuildCommonResponse()
    w_type = args.w_type

    m_g_id = player.guild.g_id

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 'no':
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    # {膜拜编号：[资源类型,资源消耗量,获得公会经验,获得公会资金,获得个人贡献值]}
    worship_info = game_configs.base_config.get('worship').get(w_type)

    if worship_info[0] == 1:  # 1金币  2元宝
        if worship_info[1] > player.finance.coin:
            response.result = False
            response.message = "银两不足"
            return response.SerializeToString()
    else:
        if worship_info[1] > player.finance.gold:
            response.result = False
            response.message = "元宝不足"
            return response.SerializeToString()

    if (int(time.time())-player.guild.worship_time) < (60*60*24):
        if player.base_info.guild_worship_times > player.guild.worship:
            player.guild.worship += 1
            player.guild.contribution += worship_info[4]
            player.guild.all_contribution += worship_info[4]
            guild_obj.fund += worship_info[3]
            guild_obj.exp += worship_info[2]
        else:
            response.result = False
            response.message = "今天的膜拜次数已用完"
            return response.SerializeToString()
    else:
        localtime = time.localtime(time.time())
        new_time = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', localtime), '%Y-%m-%d %H:%M:%S'))
        player.guild.worship = 1
        player.guild.contribution += worship_info[4]
        player.guild.all_contribution += worship_info[4]
        guild_obj.fund += worship_info[3]
        guild_obj.exp += worship_info[2]
        player.guild.worship_time = new_time

    if guild_obj.exp >= game_configs.guild_config.get(guild_obj.level).exp:
        guild_obj.exp -= game_configs.guild_config.get(guild_obj.level).exp
        guild_obj.level += 1
        remote_gate.add_guild_to_rank_remote(guild_obj.g_id, guild_obj.level + (guild_obj.fund * 100))

    player.guild.save_data()
    guild_obj.save_data()

    # 根据膜拜类型判断减什么钱，然后扣除
    if worship_info[0] == 1:  # 1金币  2元宝
        player.finance.coin -= worship_info[1]
    else:
        player.finance.consume_gold(worship_info[1])
    player.finance.save_data()
    response.result = True
    response.message = "膜拜成功"
    tlog_action.log('GuildWorship', player, m_g_id, w_type)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_rank_810(data, player):
    """获取公会排行 """
    response = GuildRankProto()

    # 得到公会排行
    ranks = remote_gate.get_guild_rank_remote()
    rank_num = 1
    for uuid, _rank in ranks.items():
        data1 = tb_guild_info.getObj(uuid).hgetall()
        if data1:
            guild_obj = Guild()
            guild_obj.init_data(data1)
            guild_rank = response.guild_rank.add()
            guild_rank.g_id = guild_obj.g_id
            guild_rank.rank = rank_num
            rank_num += 1
            guild_rank.name = guild_obj.name
            guild_rank.level = guild_obj.level

            president_id = guild_obj.p_list.get(1)[0]
            char_obj = tb_character_info.getObj(president_id)
            if char_obj.exists():
                guild_rank.president = char_obj.hget('nickname')
            else:
                guild_rank.president = u'错误'
                logger.error('guild rank, president player not fond,id:%s', president_id)

            guild_rank.p_num = guild_obj.p_num
            guild_rank.record = guild_obj.record

    response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_role_list_811(data, player):
    """角色列表 """
    response = GuildRoleListProto()
    m_g_id = player.guild.g_id
    if m_g_id == 'no':
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
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
                character_info = tb_character_info.getObj(role_id).hgetall()
                if character_info:
                    role_info = response.role_info.add()
                    role_info.p_id = role_id

                    if character_info.get('nickname'):
                        role_info.name = character_info['nickname']
                    else:
                        role_info.name = u'无名'
                    role_info.level = character_info['level']

                    role_info.position = character_info['position']
                    role_info.all_contribution = character_info['all_contribution']

                    role_info.k_num = character_info['k_num']

        response.result = True
        return response.SerializeToString()
    response.result = False
    response.message = "p list is none"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_info_812(data, player):
    """获取公会信息 """
    response = GuildInfoProto()
    m_g_id = player.guild.g_id
    if m_g_id == 'no':
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    response.result = True
    guild_info = response.guild_info
    guild_info.g_id = m_g_id
    guild_info.name = guild_obj.name
    guild_info.p_num = guild_obj.p_num
    guild_info.level = guild_obj.level
    guild_info.exp = guild_obj.exp
    guild_info.fund = guild_obj.fund
    guild_info.call = guild_obj.call
    guild_info.record = guild_obj.record
    guild_info.my_position = player.guild.position
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_apply_list_813(data, player):
    """获取申请列表 """
    response = ApplyListProto()
    m_g_id = player.guild.g_id
    if m_g_id == 'no':
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_apply = guild_obj.apply

    for role_id in guild_apply:
        character_info = tb_character_info.getObj(role_id).hgetall()
        if character_info:
            role_info = response.role_info.add()
            role_info.p_id = role_id
            if character_info['nickname']:
                role_info.name = character_info['nickname']
            else:
                role_info.name = u'无名'
            role_info.level = character_info['level']
            role_info.vip_level = character_info['vip_level']
            ap = 1
            if character_info['attackPoint'] is not None:
                ap = int(character_info['attackPoint'])
            role_info.fight_power = ap

    response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def be_change_president_1801(is_online, player):
    """获取申请列表 """
    player.guild.position = 1
    player.guild.save_data()
    return True


@remoteserviceHandle('gate')
def invite_join_1803(data, player):
    """邀请加入军团 """
    args = InviteJoinRequest()
    args.ParseFromString(data)
    response = InviteJoinResponse()
    user_id = args.user_id

    m_g_id = player.guild.g_id

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 'no':
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()
    if m_g_id == 'no':
        response.result = False
        response.message = "没有公会"
        return response.SerializeToString()

    if player.guild.position != 1:
        logger.error('invite_join_1802 : you are`t president')
        response.result = False
        response.message = "您不是会长"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_p_max = game_configs.guild_config.get(guild_obj.level).p_max

    if guild_obj.get_p_num()+1 > guild_p_max:
        response.result = False
        response.message = "超出公会人数上限"
        return response.SerializeToString()

    if not guild_obj.invite_join.get(user_id):
        for u_id, i_time in guild_obj.invite_join.items():
            if i_time + game_configs.base_config.get('guildInviteTime') > int(time.tiem()):
                del guild_obj.invite_join[u_id]
        if len(guild_obj.invite_join)+1 > guild_p_max:
            response.result = False
            response.message = "超出可邀请人数上限"
            return response.SerializeToString()

        mail_id = game_configs.base_config.get('guildInviteMail')
        mail = Mail_PB()
        mail.config_id = mail_id
        mail.receive_id = user_id
        mail.mail_type = MailComponent.TYPE_MESSAGE
        mail.send_time = int(time.time())
        mail.invite_name = player.base_info.base_name
        mail.guild_name = guild_obj.name
        mail.guild_person_num = guild_obj.p_num
        mail.guild_level = guild_obj.level
        mail.guild_id = guild_obj.g_id
        mail_data = mail.SerializePartialToString()

        if not netforwarding.push_message('receive_mail_remote',
                                          user_id,
                                          mail_data):
            logger.error('pvp high rank award mail fail, \
                    player id:%s', player.base_info.id)

            response.result = False
            response.result_no = 800
            return response.SerializeToString()
        else:
            logger.debug('pvp high rak award mail,mail_id:%s',
                         mail_id)

    guild_obj.invite_join[user_id] = int(time.time())

    guild_obj.save_data()
    response.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def deal_invite_join_1804(data, player):
    """处理邀请加入军团 """
    args = DealInviteJoinRequest()
    args.ParseFromString(data)
    response = DealInviteJoinResResponse()
    guild_id = args.guild_id
    res = args.res
    response.result = True

    data1 = tb_guild_info.getObj(guild_id).hgetall()
    if not data1:
        response.result = False
        response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    if not guild_obj.invite_join.get(player.base_info.id):
        response.result = False
        response.message = "未知错误"
        return response.SerializeToString()

    if res:
        if player.guild.g_id != 'no':
            response.result = False
            response.message = "你已经有军团了"

        if guild_obj.get_p_num()+1 > game_configs.guild_config.get(guild_obj.level).p_max:
            response.result = False
            response.message = "超出公会人数上限"

        open_stage_id = game_configs.base_config.get('guildOpenStage')
        if player.stage_component.get_stage(open_stage_id).state == -2:
            response.result = False
            response.message = "未完成指定关卡"
            # response.result_no = 837

        if response.result:
            player.guild.g_id = guild_id.encode('utf-8')
            player.guild.position = 5
            player.guild.contribution = 0
            player.guild.all_contribution = 0
            player.guild.k_num = 0
            player.guild.exit_time = 1

            if guild_obj.p_list.get(5):
                p_list1 = guild_obj.p_list.get(5)
                p_list1.append(player.base_info.id)
                guild_obj.p_list.update({5: p_list1})
            else:
                guild_obj.p_list.update({5: [player.base_info.id]})
            guild_obj.p_num += 1

            remote_gate.login_guild_chat_remote(player.dynamic_id,
                                                player.guild.g_id)

        player.guild.save_data()

    del guild_obj.invite_join[player.base_info.id]
    guild_obj.save_data()

    return response.SerializeToString()
