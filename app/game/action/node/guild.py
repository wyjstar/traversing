# -*- coding:utf-8 -*-
"""
created by cui
"""
import re
import time
from app.game.core.PlayersManager import PlayersManager
from shared.common_logic.guild import Guild
from app.proto_file.guild_pb2 import *
from app.game.redis_mode import tb_guild_info
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from shared.db_opear.configs_data import game_configs
from shared.utils import trie_tree
from shared.tlog import tlog_action
from app.game.action.root import netforwarding
from app.game.core.stage.stage import Stage
from app.proto_file.db_pb2 import Heads_DB
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from shared.db_opear.configs_data.data_helper import parse
from app.game.core.mail_helper import send_mail
from app.game.core import rank_helper
import cPickle


remote_gate = GlobalObject().remote.get('gate')


@remoteserviceHandle('gate')
def create_guild_801(data, player):
    """创建公会 """
    args = CreateGuildRequest()
    args.ParseFromString(data)
    g_name = args.name
    icon_id = args.icon_id
    response = CreateGuildResponse()
    p_id = player.base_info.id
    g_id = player.guild.g_id

    if game_configs.base_config.get('create_level') > player.base_info.level:
        response.res.result = False
        # response.res.message = "等级不够"
        response.res.result_no = 811
        return response.SerializeToString()

    if game_configs.base_config.get('create_money') > player.finance.gold:
        response.res.result = False
        response.res.result_no = 102
        return response.SerializeToString()

    if g_id != 0:
        response.res.result = False
        response.res.result_no = 843
        # response.res.message = "您已加入公会"
        return response.SerializeToString()

    if not g_name or g_name.isdigit():
        response.res.result = False
        response.res.result_no = 840  # 军团名不合法
        return response.SerializeToString()

    match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]',
                      g_name)
    if match:
        response.res.result = False
        # response.res.message = "公会名不合法"
        response.res.result_no = 840  # 军团名不合法
        return response.SerializeToString()

    if trie_tree.check.replace_bad_word(g_name).encode("utf-8") != g_name:
        response.res.result = False
        # response.res.message = "公会名不合法"
        response.res.result_no = 840  # 军团名不合法
        return response.SerializeToString()

    if len(g_name) > 18:
        response.res.result = False
        response.res.message = "名称超过字数限制"
        response.res.result_no = 840  # 军团名不合法
        return response.SerializeToString()

    # 判断有没有重名
    guild_name_data = tb_guild_info.getObj('names')
    _result = guild_name_data.hget(g_name)
    if _result:
        response.res.result = False
        # response.res.message = "此名已存在"
        response.res.result_no = 841  # 名称已存在
        return response.SerializeToString()

    def func():
        # 创建公会
        create_res = remote_gate['world']. \
            create_guild_remote(p_id,
                                g_name,
                                icon_id,
                                player.guild.apply_guilds)
        # create_res = cPickle.loads(create_res)
        if not create_res.get('res'):
            raise ValueError("Guild name repeat!")
            return

        guild_info = create_res.get('guild_info')
        rank_helper.add_rank_info('GuildLevel', guild_info.get('id'), 1)

        player.guild.g_id = guild_info.get('id')
        player.guild.today_contribution = 0
        player.guild.position = 1
        player.guild.apply_guilds = []
        player.guild.save_data()

        # 加入公会聊天
        remote_gate.login_guild_chat_remote(player.dynamic_id,
                                            player.guild.g_id)

    need_gold = game_configs.base_config.get('create_money')
    if not player.pay.pay(need_gold, const.GUILD_CREATE, func):
        response.res.result = False
        response.res.result_no = 800
        logger.error('create_guild error! pid:%d' % p_id)
        return response.SerializeToString()

    response.res.result = True
    tlog_action.log('CreatGuild', player, player.guild.g_id,
                    player.base_info.level)
    print response, '===========================222create'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def join_guild_802(data, player):
    """申请加入公会 """
    p_id = player.base_info.id
    args = JoinGuildRequest()
    args.ParseFromString(data)
    response = JoinGuildResponse()
    g_id = args.g_id
    m_g_id = player.guild.g_id
    m_exit_time = player.guild.exit_time
    the_time = int(time.time())-m_exit_time

    if m_exit_time != 1 and the_time < \
            game_configs.base_config.get('exit_time'):
        # "退出公会半小时内不可加入公会"
        response.res.result = False
        response.res.result_no = 842
        response.spare_time = game_configs.base_config.get('exit_time') \
            - the_time
        return response.SerializeToString()

    open_stage_id = game_configs.base_config.get('guildOpenStage')
    if player.stage_component.get_stage(open_stage_id).state != 1:
        # "未完成指定关卡"
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

    if m_g_id != 0:
        # "您已加入公会"
        response.res.result = False
        response.res.result_no = 843
        return response.SerializeToString()

    if g_id in player.guild.apply_guilds:
        # 已经申请过此军团
        response.res.result = False
        response.res.result_no = 861
        return response.SerializeToString()

    remote_res = remote_gate['world'].join_guild_remote(g_id, p_id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    remote_gate.is_online_remote(
        'modify_user_guild_info_remote',
        remote_res.get('captain_id'), {'cmd': 'join_guild'})

    player.guild.apply_guilds.append(g_id)
    player.guild.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def exit_guild_803(data, player):
    """退出公会 """
    p_id = player.base_info.id
    dynamicid = player.dynamic_id
    response = ExitGuildResponse()
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].exit_guild_remote(g_id, p_id)
    remote_res = cPickle.loads(remote_res)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    if remote_res.get('no') == 1:
        # 解散公会
        # 删除公会聊天室
        remote_gate.del_guild_room_remote(g_id)
        # 删除排行
        rank_helper.remove_rank('GuildLevel', g_id)
        # 删除申请加入军团玩家的申请信息
        del_apply_cache(remote_res.get('apply_ids'))
        mail_id = 304
    elif remote_res.get('no') == 2:
        # 团长转让
        # 退出公会聊天
        remote_gate.logout_guild_chat_remote(dynamicid)
        mail_id = 304
    else:  # no == 3
        # 非团长退出
        # 退出公会聊天
        remote_gate.logout_guild_chat_remote(dynamicid)
        player.guild.exit_time = int(time.time())
        mail_id = 305

    send_mail(mail_id, receive_id=p_id,
              guild_name=remote_res.get('guild_name'))

    player.guild.g_id = 0
    player.guild.contribution = 0
    player.guild.all_contribution = 0
    player.guild.today_contribution = 0
    player.guild.position = 3
    player.guild.save_data()

    response.res.result = True
    tlog_action.log('ExitGuild', player, g_id)
    return response.SerializeToString()


def del_apply_cache(apply_ids):
    for p_id in apply_ids:
        if not netforwarding.push_message('del_apply_cache_remote',
                                          p_id, guild_obj.g_id):
            logger.error('del_apply_cache push message fail id:%d' % p_id)


@remoteserviceHandle('gate')
def del_apply_cache_remote(g_id, is_online, player):
    player.guild.apply_guilds.remove(g_id)
    player.guild.save_data()
    return True


@remoteserviceHandle('gate')
def modify_user_guild_info_remote(data, player):
    if data['cmd'] == 'change_president':
        proto_data = PositionChange()
        proto_data.position = data['position']
        player.guild.position = data['position']
        player.guild.save_data()
        remote_gate.push_object_remote(1815,
                                       proto_data.SerializeToString(),
                                       [player.dynamic_id])
    elif data['cmd'] == 'exit_guild':
        player.guild.position = data['position']
        player.guild.save_data()
    elif data['cmd'] == 'deal_apply':
        if player.guild.g_id != 0:
            return 0
        remote_gate.login_guild_chat_remote(player.dynamic_id,
                                            data['guild_id'])
        player.guild.g_id = data['guild_id']
        player.guild.contribution = 0
        player.guild.all_contribution = 0
        player.guild.today_contribution = 0
        player.guild.position = 3
        player.guild.exit_time = 1
        player.guild.apply_guilds = []

        player.guild.save_data()
        remote_gate.push_object_remote(1814,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'deal_apply1':
        if data['guild_id'] in player.guild.apply_guilds:
            player.guild.apply_guilds.remove(data['guild_id'])
            player.guild.save_data()
    elif data['cmd'] == 'kick':
        remote_gate.logout_guild_chat_remote(player.dynamic_id)
        player.guild.g_id = 0
        player.guild.save_data()
        remote_gate.push_object_remote(814,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'join_guild':
        remote_gate.push_object_remote(850,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'canjoinguild':
        open_stage_id = game_configs.base_config.get('guildOpenStage')
        if player.stage_component.get_stage(open_stage_id).state != 1:
            return 0
        else:
            return 1
    return 1


@remoteserviceHandle('gate')
def editor_call_804(data, player):
    """编辑公告 """
    return
    # TODO
    p_id = player.base_info.id
    args = EditorCallRequest()
    args.ParseFromString(data)
    response = EditorCallResponse()
    call = args.call
    if len(call) > 150:
        response.res.result = True
        response.res.result_no = 848
        # response.res.message = "公告内容超过字数限制"
        return response.SerializeToString()
    data1 = tb_guild_info.getObj(player.guild.g_id).hgetall()
    if not data1:
        response.res.result = False
        response.res.result_no = 844
        # response.res.message = "公会ID错误"
        return response.SerializeToString()
    guild_obj = Guild()
    guild_obj.init_data(data1)

    position = player.guild.position
    p_list = guild_obj.p_list
    position_p_list = p_list.get(position)

    if p_id in position_p_list:
        if position > 2:
            response.res.result = False
            response.res.result_no = 849
            # response.res.message = "权限不够"
            return response.SerializeToString()

        if call:
            new_call = trie_tree.check.replace_bad_word(call).encode("utf-8")

        guild_obj.editor_call(call)
        guild_obj.save_data()
        response.res.result = True
        return response.SerializeToString()
    else:
        response.res.result = False
        response.res.result_no = 850
        # response.res.message = "您不在此公会"
        return response.SerializeToString()


@remoteserviceHandle('gate')
def deal_apply_805(data, player):
    """处理加入公会申请 """
    args = DealApplyRequest()
    args.ParseFromString(data)
    response = DealApplyResponse()

    pb_p_ids = args.p_ids
    p_ids = []
    for _p_id in pb_p_ids:
        p_ids.append(_p_id)
    res_type = args.res_type
    g_id = player.guild.g_id
    p_id = player.base_info.id

    remote_res = remote_gate['world'].cheak_deal_apply_remote(g_id, p_ids,
                                                              p_id, res_type)
    if not remote_res.get('res'):
        response.res.result = False
        print remote_res.get('no'), '=============deal apply 4'
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    print res_type, '=============deal apply 2'
    if res_type == 1:
        for p_id in p_ids:
            data = {'guild_id': player.guild.g_id,
                    'position': 3,
                    'contribution': 0,
                    'all_contribution': 0,
                    'today_contribution': 0,
                    'apply_guilds': [],
                    'exit_time': 1}
            is_online = remote_gate.is_online_remote(
                'modify_user_guild_info_remote',
                p_id,
                {'cmd': 'deal_apply', "guild_id": player.guild.g_id})

            if is_online == "notonline":
                p_guild_obj = tb_character_info.getObj(p_id)
                info = p_guild_obj.hget('guild_id')
                if info != 0:
                    continue
                p_guild_obj.hmset(data)
            elif is_online == 0:  # 玩家在线，已经加入军团
                response.p_ids.append(p_id)
                continue

            response.p_ids.append(p_id)
            send_mail(conf_id=303, receive_id=p_id,
                      guild_name=remote_res['guild_name'])
            tlog_action.log('DealJoinGuild', player, g_id,
                            p_id, 1)

    else:
        if res_type == 3:
            p_ids = remote_res['applys']

        for p_id in p_ids:
            tlog_action.log('DealJoinGuild', player, g_id,
                            p_id, res_type)

            is_online = remote_gate.is_online_remote(
                'modify_user_guild_info_remote',
                p_id,
                {'cmd': 'deal_apply1', "guild_id": player.guild.g_id})

            if is_online == "notonline":
                p_guild_obj = tb_character_info.getObj(p_id)
                apply_guilds = p_guild_obj.hget('apply_guilds')
                if g_id in apply_guilds:
                    apply_guilds.remove(g_id)
                p_guild_obj.hmset({'apply_guilds': apply_guilds})

    print res_type, '=============deal apply 3'
    remote_gate['world'].deal_apply_remote(g_id, p_ids,
                                           res_type)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def change_president_806(data, player):
    """转让会长 """
    return
    # TODO
    dynamicid = player.dynamic_id
    p_id = player.base_info.id
    args = ChangePresidentRequest()
    args.ParseFromString(data)
    response = ChangePresidentResponse()
    p_p_id = args.p_id
    m_g_id = player.guild.g_id

    data1 = tb_guild_info.getObj(m_g_id).hgetall()

    if m_g_id == 0:
        response.res.result = False
        response.res.result_no = 846
        # response.res.message = "您还未加入公会"
        return response.SerializeToString()

    if not data1:
        response.res.result = False
        response.res.result_no = 844
        # response.res.message = "公会ID错误"
        return response.SerializeToString()

    if player.guild.position != 1:
        logger.debug('guild change president : you are`t president')
        response.res.result = False
        response.res.result_no = 849
        # response.res.message = "您不是会长"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    p_list = guild_obj.p_list
    for num in range(2, 4):
        p_list1 = p_list.get(num)
        if p_list1 and p_p_id in p_list1:
            p_list1.remove(p_p_id)
            p_list3 = p_list.get(3)
            p_list3.append(p_id)
            p_list.update({num: p_list1, 3: p_list3, 1: [p_p_id]})
            guild_obj.p_list = p_list
            guild_obj.save_data()

            info = tb_character_info.getObj(p_p_id).hgetall()
            if info.get("guild_id") != player.guild.g_id:
                logger.debug('guild change president : player don`t in guild')
                response.res.result = False
                response.res.result_no = 850
                # response.res.message = "此玩家不在公会"
                return response.SerializeToString()

            data = {'position': 1}
            is_online = remote_gate.is_online_remote(
                'modify_user_guild_info_remote',
                p_p_id, {'cmd': 'change_president', 'position': 1})

            if is_online == "notonline":
                p_guild_data = tb_character_info.getObj(p_p_id)
                p_guild_data.hmset(data)

            player.guild.position = 3
            player.guild.save_data()

            send_mail(conf_id=307, receive_id=p_p_id, guild_name=guild_obj.name)

            response.res.result = True
            # response.res.message = "转让成功"
            tlog_action.log('GuildChangePresident', player, m_g_id, p_p_id)
            return response.SerializeToString()
    # 没有找到此玩家
    logger.debug('guild change president : dont find player')
    response.result = False
    response.res.result_no = 858
    # response.message = "玩家不在此公会"
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kick_807(data, player):
    """踢人 """
    return
    # TODO
    args = KickRequest()
    args.ParseFromString(data)
    response = KickResponse()
    p_ids = args.p_ids
    m_g_id = player.guild.g_id
    if player.guild.position > 2:
        logger.debug('guild kick:you are not position:%s', player.guild.position)
        response.res.result = False
        response.res.result_no = 849
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    guild_obj = Guild()
    guild_obj.init_data(data1)
    p_list = guild_obj.p_list
    for p_id in p_ids:
        for num in range(2, 4):
            p_list1 = p_list.get(num)
            if not p_list1 or p_id not in p_list1:
                continue

            be_kick_obj = tb_character_info.getObj(p_id)
            if be_kick_obj.hget('guild_id') == 0:
                response.res.result = False
                response.res.result_no = 800
                return response.SerializeToString()
            if player.guild.position == 2 and num != 3:
                response.res.result = False
                response.res.result_no = 849
                return response.SerializeToString()

            p_list1.remove(p_id)
            p_list.update({num: p_list1})
            guild_obj.p_list = p_list
            guild_obj.p_num -= 1
            guild_obj.save_data()

            data = {'guild_id': 0,
                    'position': 3,
                    'contribution': 0,
                    'all_contribution': 0,
                    'today_contribution': 0,
                    'apply_guilds': [],
                    'exit_time': 1}
            # TODO 玩家被提出，或者退出军团以后，膜拜的记录清理不清理。
            is_online = remote_gate.is_online_remote(
                'modify_user_guild_info_remote', p_id, {'cmd': 'kick'})
            if is_online == "notonline":
                p_guild_data = tb_character_info.getObj(p_id)
                p_guild_data.hmset(data)

            send_mail(conf_id=302, receive_id=p_id, guild_name=guild_obj.name)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def bless_809(data, player):
    """膜拜 """
    return
    # TODO
    args = BlessRequest()
    args.ParseFromString(data)
    response = BlessResponse()
    bless_type = args.bless_type

    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 0:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    # {祈福编号：[资源类型,资源消耗量,凝聚力,福运,获得个人贡献值]}
    worship_info = game_configs.base_config.get('worship').get(bless_type)

    if worship_info[0] == 1:  # 1金币  2元宝
        if worship_info[1] > player.finance.coin:
            response.res.result = False
            response.res.result_no = 101
            # response.res.message = "银两不足"
            return response.SerializeToString()
    else:
        if worship_info[1] > player.finance.gold:
            response.res.result = False
            response.res.result_no = 102
            return response.SerializeToString()

    if player.base_info.guild_worship_times <= player.guild.bless_times:
        response.res.result = False
        response.res.result_no = 854
        # response.message = "今天的膜拜次数已用完"
        return response.SerializeToString()

    # 根据膜拜类型判断减什么钱，然后扣除
    if worship_info[0] == 1:  # 1金币  2元宝
        player.finance.coin -= worship_info[1]
    else:
        player.finance.consume_gold(worship_info[1], const.GUILD_BLESS)

    # 逻辑
    player.guild.bless[0] += 1
    player.guild.contribution += worship_info[4]
    player.guild.all_contribution += worship_info[4]
    player.guild.bless[2] += worship_info[4]
    guild_obj.bless[1] += worship_info[3]
    if player.guild.bless[0] == 1:
        guild_obj.bless[0] += 1
    guild_obj.exp += worship_info[2]

    if guild_obj.exp >= game_configs.guild_config.get(8).get(guild_obj.level).exp:
        guild_obj.exp -= game_configs.guild_config.get(8).get(guild_obj.level).exp
        guild_obj.level += 1
        rank_helper.add_rank_info('GuildLevel',
                                  guild_obj.g_id, guild_obj.level)

    player.guild.save_data()
    guild_obj.save_data()

    player.finance.save_data()

    response.res.result = True
    # response.message = "膜拜成功"
    tlog_action.log('GuildWorship', player, m_g_id, bless_type)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_rank_810(data, player):
    """获取公会排行 """
    args = GetGuildRankRequest()
    args.ParseFromString(data)
    response = GetGuildRankResponse()
    rank_type = args.rank_type
    min_rank = args.min_rank
    max_rank = args.max_rank

    if rank_type == 1:
        rank_num = min_rank
        # 得到公会排行
        rank_info = rank_helper.get_rank('GuildLevel',
                                         min_rank, max_rank)
        print rank_info, '========================rankinfo'
        for (_g_id, _rank) in rank_info:
            g_id = int(_g_id)
            deal_rank_response_info(player, response, g_id, rank_num)
            rank_num += 1
        response.res.result = True
    elif rank_type == 2:  # 推荐列表
        response.flag = 0
        if player.guild.g_id != 0:
            response.res.result = False
            response.res.result_no = 843
            return response.SerializeToString()
        if min_rank == 1:
            player.guild.guild_rank_flag = 0
        if min_rank <= len(player.guild.apply_guilds):  # 申请列表不为0的时候 一定是false
            if max_rank <= len(player.guild.apply_guilds):
                rank_num = min_rank
                for x in range(min_rank-1, max_rank):
                    g_id = player.guild.apply_guilds[x]
                    deal_rank_response_info(player, response, g_id, rank_num)
                    rank_num += 1
            else:  # len(player.guild.apply_guilds) < max_rank:
                rank_num = min_rank
                for x in range(min_rank-1, len(player.guild.apply_guilds)):
                    g_id = player.guild.apply_guilds[x]
                    deal_rank_response_info(player, response, g_id, rank_num)
                    rank_num += 1

                rank_info = rank_helper.get_rank('GuildLevel', 1, 9999)
                guild_rank_flag = 0
                for (_g_id, _rank) in rank_info:
                    g_id = int(_g_id)
                    guild_rank_flag += 1
                    if g_id in player.guild.apply_guilds:
                        continue
                    if not deal_rank_response_info(player, response, g_id,
                                                   rank_num,
                                                   rank_type=rank_type):
                        continue

                    rank_num += 1
                    if rank_num > max_rank:
                        break
                player.guild.guild_rank_flag = guild_rank_flag
        else:  # min_rank > 申请个数 无申请
            # 需要上次查到哪的 redis 排行
            rank_num = min_rank
            guild_rank_flag = player.guild.guild_rank_flag
            rank_info = rank_helper.get_rank('GuildLevel', 1, 9999)
            if len(rank_info) == 0:
                response.flag = 1
                response.res.result = True
                return response.SerializeToString()
            if guild_rank_flag >= len(rank_info):
                response.res.result = True
                return response.SerializeToString()
            for x in range(player.guild.guild_rank_flag, len(rank_info)):
                guild_rank_flag = x
                (_g_id, _rank) = rank_info[x]
                g_id = int(_g_id)
                if g_id in player.guild.apply_guilds:
                    continue
                if not deal_rank_response_info(player, response, g_id,
                                               rank_num,
                                               rank_type=rank_type):
                    continue

                rank_num += 1
                if rank_num > max_rank:
                    break
            player.guild.guild_rank_flag = guild_rank_flag

    player.guild.save_data()
    response.res.result = True
    return response.SerializeToString()


def deal_rank_response_info(player, response, g_id, rank_num, rank_type=1):
    data1 = tb_guild_info.getObj(g_id).hgetall()
    # if data1:
    guild_obj = Guild()
    guild_obj.init_data(data1)
    if rank_type == 2 and guild_obj.get_p_num() >= \
            game_configs.guild_config.get(8).get(guild_obj.build[1]).p_max:
        return False
    guild_rank = response.guild_rank.add()
    guild_rank.g_id = guild_obj.g_id
    guild_rank.rank = rank_num
    guild_rank.name = guild_obj.name
    guild_rank.level = 1
    guild_rank.icon_id = guild_obj.icon_id

    president_id = guild_obj.p_list.get(1)[0]
    char_obj = tb_character_info.getObj(president_id)
    if char_obj.exists():
        guild_rank.president = char_obj.hget('nickname')
    else:
        guild_rank.president = u'错误'
        logger.error('guild rank, president player not fond,id:%s',
                     president_id)

    guild_rank.p_num = guild_obj.get_p_num()
    guild_rank.call = guild_obj.call
    if player.base_info.id in guild_obj.apply:
        guild_rank.be_apply = 1
    else:
        guild_rank.be_apply = 0
    return True


@remoteserviceHandle('gate')
def get_role_list_811(data, player):
    """角色列表 """
    response = GetGuildMemberListResponse()
    m_g_id = player.guild.g_id
    if m_g_id == 0:
        response.res.result = False
        response.res.result_no = 846
        # response.res.message = "没有公会"
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1:
        response.res.result = False
        response.res.result_no = 844
        # response.res.message = "id error"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_p_list = guild_obj.p_list
    print guild_p_list, '================guild p list '
    if not guild_p_list.values():
        response.res.result = False
        response.res.result_no = 800
        # response.message = "p list is none"
        return response.SerializeToString()

    for p_list in guild_p_list.values():
        for role_id in p_list:
            character_info = tb_character_info.getObj(role_id).hgetall()
            if not character_info:
                continue
            role_info = response.role_info.add()
            role_info.p_id = role_id

            if character_info.get('nickname'):
                role_info.name = character_info['nickname']
            else:
                role_info.name = u'无名'
            role_info.level = character_info['level']

            role_info.position = guild_obj.get_position(role_id)
            role_info.all_contribution = \
                character_info['all_contribution']
            role_info.contribution = character_info['contribution']
            role_info.day_contribution = character_info['today_contribution']
            role_info.vip_level = character_info['vip_level']

            ap = 1
            if character_info['attackPoint'] is not None:
                ap = int(character_info['attackPoint'])
            role_info.fight_power = ap
            role_info.is_online = remote_gate.online_remote(role_id)

            heads = Heads_DB()
            heads.ParseFromString(character_info['heads'])
            role_info.user_icon = heads.now_head

            today_contribution = 0
            if time.localtime(character_info['bless'][3]).tm_yday == \
                    time.localtime().tm_yday:
                today_contribution = character_info['bless'][2]
            role_info.contribution = today_contribution

    response.res.result = True
    print response, '==========================guild player list'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_info_812(data, player):
    """获取公会信息 """
    response = GetGuildInfoResponse()
    g_id = player.guild.g_id
    if g_id == 0:
        # "没有公会"
        logger.error('get_guild_info_812, guild id == 0')
        response.res.result = False
        response.res.result_no = 846
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(g_id).hgetall()
    if not data1:
        # "公会ID错误"
        logger.error('get_guild_info_812, guild error')
        response.res.result = False
        response.res.result_no = 844
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    position = guild_obj.get_position(player.base_info.id)
    response.g_id = g_id
    response.name = guild_obj.name
    response.member_num = guild_obj.get_p_num()
    response.contribution = guild_obj.contribution
    response.all_contribution = guild_obj.all_contribution
    response.icon_id = guild_obj.icon_id
    response.call = guild_obj.call
    response.position = position
    response.all_zan_num = guild_obj.praise_num
    response.zan_money = guild_obj.praise_money
    response.captain_zan_receive_state = guild_obj.receive_praise_state
    for build_type, build_level in guild_obj.build.items():
        build_info_pb = response.build_info.add()
        build_info_pb.build_type = build_type
        build_info_pb.build_level = build_level

    response.my_contribution = player.guild.contribution
    response.my_all_contribution = player.guild.all_contribution
    response.my_day_contribution = player.guild.today_contribution

    response.last_zan_time = player.guild.praise_time
    response.zan_num = player.guild.praise_num

    response.luck_num = player.guild.bless_times
    response.bless_num = player.guild.bless_times
    response.bless_state = player.guild.bless_times

    for bless_gift_no in player.guild.bless_gifts:
        response.bless_gift.append(bless_gift_no)
    rank_no = rank_helper.get_rank_by_key('GuildLevel',
                                          g_id)
    response.my_guild_rank = rank_no
    if position == 1:
        response.captain_name = player.base_info.base_name
        response.captain_level = player.base_info.level
        response.captain_power = int(player.line_up_component.combat_power)
        response.captain_vip_level = player.base_info.vip_level
        response.captain_icon = player.base_info.head

    else:
        president_id = guild_obj.p_list.get(1)[0]
        character_info = tb_character_info.getObj(president_id).hgetall()
        if character_info:
            response.captain_name = character_info['nickname']
            response.captain_level = character_info['level']
            ap = 1
            if character_info['attackPoint'] is not None:
                ap = int(character_info['attackPoint'])
            response.captain_power = ap
            response.captain_vip_level = character_info['vip_level']

            heads = Heads_DB()
            heads.ParseFromString(character_info['heads'])
            response.captain_icon = heads.now_head
    if position <= 2:
        if guild_obj.apply:
            response.have_apply = 1
        else:
            response.have_apply = 0

    response.res.result = True
    print response, '================================================11111'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_apply_list_813(data, player):
    """获取申请列表 """
    response = GetApplyListResponse()
    m_g_id = player.guild.g_id
    if m_g_id == 0:
        # "没有公会"
        response.res.result = False
        response.res.result_no = 846
        return response.SerializeToString()

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1:
        # "id error"
        response.res.result = False
        response.res.result_no = 844
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
            role_info.is_online = remote_gate.online_remote(role_id)

            heads = Heads_DB()
            heads.ParseFromString(character_info['heads'])
            role_info.user_icon = heads.now_head

    response.res.result = True
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
    return
    # TODO
    args = InviteJoinRequest()
    args.ParseFromString(data)
    response = InviteJoinResponse()
    user_id = args.user_id

    m_g_id = player.guild.g_id

    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 0:
        response.res.result = False
        response.res.result_no = 800
        # response.message = "公会ID错误"
        return response.SerializeToString()

    if player.guild.position == 3:
        logger.error('invite_join_1802 : you are`t president')
        response.res.result = False
        response.res.result_no = 849
        # response.res.message = "您不是会长"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)

    guild_p_max = game_configs.guild_config.get(8).get(guild_obj.level).p_max

    if guild_obj.get_p_num()+1 > guild_p_max:
        response.res.result = False
        response.res.result_no = 845
        # response.message = "超出公会人数上限"
        return response.SerializeToString()

    info = tb_character_info.getObj(user_id).hget('guild_id')
    if info != 0:
        response.res.result = False
        # response.res.message = "对方已有军团"
        response.res.result_no = 865
        return response.SerializeToString()

    open_stage_id = game_configs.base_config.get('guildOpenStage')
    is_online = remote_gate.is_online_remote('modify_user_guild_info_remote', user_id, {'cmd': 'canjoinguild'})
    if is_online == "notonline":
        character_obj = tb_character_info.getObj(user_id)
        if not character_obj.exists():
            response.res.result = False
            # response.message = "未知错误"
            response.res.result_no = 800
            return response.SerializeToString()
        stages = character_obj.hget('stage_info')
        stage_objs = {}
        flog = 1
        for stage_id_a, stage in stages.items():
            if stage_id_a == open_stage_id:
                flog = 0
                stage_obj = Stage.loads(stage)
                if stage_obj.state != 1:
                    flog = 1
        if flog:
            response.res.result = False
            # response.res.message = "对方未开启军团功能"
            response.res.result_no = 866
            return response.SerializeToString()

    elif is_online == 0:
        response.res.result = False
        # response.message = "对方未开启军团功能"
        response.res.result_no = 866
        return response.SerializeToString()

    if not guild_obj.invite_join.get(user_id):
        for u_id, i_time in guild_obj.invite_join.items():
            if i_time + game_configs.base_config.get('guildInviteTime') > int(time.time()):
                del guild_obj.invite_join[u_id]
        if len(guild_obj.invite_join)+1 > guild_p_max:
            response.res.result = False
            response.res.result_no = 845
            # response.res.message = "超出可邀请人数上限"
            return response.SerializeToString()

        mail_id = game_configs.base_config.get('guildInviteMail')
        send_mail(conf_id=mail_id, receive_id=user_id, guild_name=guild_obj.name,
                  guild_p_num=guild_obj.p_num, guild_level=guild_obj.level,
                  guild_id=guild_obj.g_id, nickname=player.base_info.base_name)

    guild_obj.invite_join[user_id] = int(time.time())

    guild_obj.save_data()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def deal_invite_join_1804(data, player):
    """处理邀请加入军团 """
    return
    # TODO
    args = DealInviteJoinRequest()
    args.ParseFromString(data)
    response = DealInviteJoinResResponse()
    guild_id = args.guild_id
    res = args.res
    response.res.result = True

    data1 = tb_guild_info.getObj(guild_id).hgetall()
    if not data1:
        player.mail_component.delete_mails([args.mail_id])
        response.res.result = False
        response.res.result_no = 844
        # response.res.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    # player.mail_component.delete_mails([args.mail_id])

    if not guild_obj.invite_join.get(player.base_info.id):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    # del guild_obj.invite_join[player.base_info.id]

    if res:
        m_exit_time = player.guild.exit_time
        the_time = int(time.time())-m_exit_time

        if m_exit_time != 1 and the_time < \
                game_configs.base_config.get('exit_time'):
            response.res.result = False
            response.res.result_no = 842
            # response.message = "退出公会半小时内不可加入公会"
            response.spare_time = game_configs.base_config.get('exit_time') \
                - the_time
            return response.SerializeToString()

        player.mail_component.delete_mails([args.mail_id])
        del guild_obj.invite_join[player.base_info.id]

        if player.guild.g_id != 0:
            response.res.result = False
            response.res.result_no = 843
            #response.message = "你已经有军团了"
            return response.SerializeToString()

        if guild_obj.get_p_num()+1 > game_configs.guild_config.get(8).get(guild_obj.level).p_max:
            response.res.result = False
            response.res.result_no = 845
            # response.message = "超出公会人数上限"
            return response.SerializeToString()

        open_stage_id = game_configs.base_config.get('guildOpenStage')
        if player.stage_component.get_stage(open_stage_id).state != 1:
            response.res.result = False
            response.res.result_no = 837
            # response.message = "未完成指定关卡"
            return response.SerializeToString()

        if response.res.result:
            player.guild.g_id = guild_obj.g_id
            player.guild.position = 3
            player.guild.contribution = 0
            player.guild.all_contribution = 0
            player.guild.k_num = 0
            player.guild.exit_time = 1

            if guild_obj.p_list.get(3):
                p_list1 = guild_obj.p_list.get(3)
                p_list1.append(player.base_info.id)
                guild_obj.p_list.update({3: p_list1})
            else:
                guild_obj.p_list.update({3: [player.base_info.id]})
            guild_obj.p_num += 1

            remote_gate.login_guild_chat_remote(player.dynamic_id,
                                                player.guild.g_id)

        player.guild.save_data()
    else:
        player.mail_component.delete_mails([args.mail_id])
        del guild_obj.invite_join[player.base_info.id]

    guild_obj.save_data()

    return response.SerializeToString()


@remoteserviceHandle('gate')
def praise_1807(data, player):
    """点赞 """
    return
    # TODO
    response = ZanResResponse()
    g_id = player.guild.g_id

    praise_num_max = game_configs.base_config.get('worShipFrequencyMax')
    if player.guild.praise_num >= praise_num_max:
        #  "次数不够"
        response.res.result = False
        response.res.result_no = 851
        return response.SerializeToString()

    remote_res = remote_gate['world'].praise_remote(g_id,
                                                    player.base_info.id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    guild_config = game_configs.guild_config.get(8).get(guild_obj.level)

    if time.localtime(player.guild.praise[1]).tm_yday != \
            time.localtime().tm_yday:
        player.guild.praise = [1, int(time.time())]
    else:
        player.guild.praise[0] += 1
        player.guild.praise[1] = int(time.time())

    if time.localtime(guild_obj.praise[2]).tm_yday != \
            time.localtime().tm_yday:
        guild_obj.praise = [1, 0, int(time.time())]
    else:
        guild_obj.praise[0] += 1
        guild_obj.praise[2] = int(time.time())

    response.zan_num = guild_obj.praise_num

    return_data = gain(player, guild_config.support, const.PraiseGift)  # 获取
    get_return(player, return_data, response.gain)
    player.guild.save_data()
    guild_obj.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def captailn_receive_1806(data, player):
    """团长领取赞的奖励 """
    return
    # TODO
    response = ReceiveResponse()

    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 0:
        response.res.result = False
        response.res.result_no = 800
        # response.message = "公会ID错误"
        return response.SerializeToString()

    if player.guild.position != 1:
        response.res.result = False
        response.res.result_no = 849
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    guild_config = game_configs.guild_config.get(8).get(guild_obj.level)

    if guild_obj.praise_num < guild_config.collectSupportNum:
        response.res.result = False
        response.res.result_no = 852
        return response.SerializeToString()

    if guild_obj.receive_praise_state:
        response.res.result = False
        response.res.result_no = 853
        return response.SerializeToString()

    guild_obj.praise[1] = 1

    return_data = gain(player, guild_config.collectSupportGift, const.ReceivePraiseGift)  # 获取
    get_return(player, return_data, response.gain)
    player.guild.save_data()
    guild_obj.save_data()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_bless_gift_1808(data, player):
    """领取祈福的奖励 """
    return
    # TODO
    args = GetBlessGiftRequest()
    args.ParseFromString(data)
    response = GetBlessGiftResponse()
    gift_no = args.gift_no

    player.guild.bless_update()

    if gift_no in player.guild.bless[1]:
        response.res.result = False
        response.res.result_no = 800
        # response.message = "公会ID错误"
        return response.SerializeToString()

    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 0:
        response.res.result = False
        response.res.result_no = 800
        # response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    guild_config = game_configs.guild_config.get(8).get(guild_obj.level)

    gift_list = guild_config.cohesion.get(gift_no)
    if not gift_list:
        response.res.result = False
        response.res.result_no = 855
        return response.SerializeToString()

    if guild_obj.bless_luck_num < gift_no:
        response.res.result = False
        response.res.result_no = 856
        return response.SerializeToString()

    for x in gift_list:
        prize = parse({106: [1, 1, x]})
        return_data = gain(player, prize, const.ReceiveBlessGift)  # 获取
        get_return(player, return_data, response.gain)

    player.guild.bless[1].append(gift_no)
    player.guild.save_data()
    guild_obj.save_data()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def find_guild_1809(data, player):
    """搜索军团 """
    args = FindGuildRequest()
    args.ParseFromString(data)
    response = FindGuildResponse()
    id_or_name = args.id_or_name

    if id_or_name.isdigit():
        guild_obj = tb_guild_info.getObj(id_or_name)
        isexist = guild_obj.exists()
    else:
        guild_name_obj = tb_guild_info.getObj('names')
        isexist = guild_name_obj.hexists(id_or_name)
        g_id = guild_name_obj.hget(id_or_name)
        guild_obj = tb_guild_info.getObj(g_id)
    if isexist:
        guild_data = guild_obj.hgetall()
        guild_rank = response.guild_info

        guild_obj = Guild()
        guild_obj.init_data(guild_data)

        rank_no = rank_helper.get_rank_by_key('GuildLevel',
                                              guild_obj.g_id)

        guild_rank.g_id = guild_obj.g_id
        guild_rank.rank = rank_no
        guild_rank.name = guild_obj.name
        guild_rank.level = 1
        guild_rank.icon_id = guild_obj.icon_id

        president_id = guild_obj.p_list.get(1)[0]
        char_obj = tb_character_info.getObj(president_id)
        if char_obj.exists():
            guild_rank.president = char_obj.hget('nickname')
        else:
            guild_rank.president = u'错误'
            logger.error('guild rank, president player not fond,id:%s',
                         president_id)

        guild_rank.p_num = guild_obj.get_p_num()
        guild_rank.call = guild_obj.call
        if player.base_info.id in guild_obj.apply:
            guild_rank.be_apply = 1
        else:
            guild_rank.be_apply = 0

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def appoint_1810(data, player):
    """任命 """
    return
    # TODO
    args = AppointRequest()
    args.ParseFromString(data)
    response = AppointResponse()
    deal_type = args.deal_type
    p_id = args.p_id

    m_g_id = player.guild.g_id
    data1 = tb_guild_info.getObj(m_g_id).hgetall()
    if not data1 or m_g_id == 0:
        response.res.result = False
        response.res.result_no = 800
        # response.message = "公会ID错误"
        return response.SerializeToString()

    guild_obj = Guild()
    guild_obj.init_data(data1)
    guild_config = game_configs.guild_config.get(8).get(guild_obj.level)

    p_list = guild_obj.p_list
    position2_list = p_list.get(2, [])
    position3_list = p_list.get(3, [])
    if deal_type == 1:
        now_positon = 2
        if position2_list and len(position2_list) >= 2:
            response.res.result = False
            response.res.result_no = 860
            return response.SerializeToString()
        if not position3_list or p_id not in position3_list:
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        position3_list.remove(p_id)
        position2_list.append(p_id)
        guild_obj.p_list = {1: [player.base_info.id],
                            2: position2_list,
                            3: position3_list}
    else:
        now_positon = 3
        if not position2_list or p_id not in position2_list:
            response.res.result = False
            response.res.result_no = 800
            return response.SerializeToString()
        position2_list.remove(p_id)
        position3_list.append(p_id)
        guild_obj.p_list = {1: [player.base_info.id],
                            2: position2_list,
                            3: position3_list}

    guild_id = tb_character_info.getObj(p_id).hget('guild_id')
    if guild_id != player.guild.g_id:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()
    data = {'position': now_positon}
    is_online = remote_gate.is_online_remote(
        'modify_user_guild_info_remote',
        p_id,
        {'cmd': 'change_president', "position": now_positon})

    if is_online == "notonline":
        p_guild_data = tb_character_info.getObj(p_id)
        p_guild_data.hmset(data)

    guild_obj.save_data()

    if deal_type == 1:
        mail_id = 306
    else:  # deal type == 2
        mail_id = 308
    send_mail(conf_id=mail_id, receive_id=p_id, guild_name=guild_obj.name)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def up_build_870(data, player):
    args = UpBuildRequest()
    args.ParseFromString(data)
    build_type = args.build_type
    response = UpBuildResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    g_id = player.guild.g_id
    if g_id == 0:
        # "没有公会"
        logger.error('up_build_870, guild id == 0')
        response.res.result = False
        response.res.result_no = 846
        return response.SerializeToString()

    remote_res = remote_gate['world'].up_build_remote(g_id, p_id,
                                                      build_type)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()
    response.res.result = True
    return response.SerializeToString()
