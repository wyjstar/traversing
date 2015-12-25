# -*- coding:utf-8 -*-
"""
created by cui
"""
import re
import time
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
#from app.game.core.stage.stage import Stage
from app.proto_file.db_pb2 import Heads_DB
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from shared.db_opear.configs_data.data_helper import parse
from app.game.core.mail_helper import send_mail
from app.game.core import rank_helper
from app.game.core.task import hook_task, CONDITIONId
from app.game.action.root.netforwarding import push_message
from shared.common_logic.feature_open import is_not_open, FO_GUILD


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

    if is_not_open(player, FO_GUILD):
        response.res.result = False
        # response.res.message = "等级不够"
        response.res.result_no = 837
        return response.SerializeToString()

    #if game_configs.base_config.get('create_level') > player.base_info.level:
        #response.res.result = False
        ## response.res.message = "等级不够"
        #response.res.result_no = 811
        #return response.SerializeToString()

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
        logger.debug("create_guild_remote=========================")
        if not create_res.get('res'):
            raise ValueError("Guild name repeat!")
            return

        guild_info = create_res.get('guild_info')
        add_guild_rank(guild_info.get('id'), guild_info.get('level'))
        # rank_value = (99999-guild_info.get('id')) + (guild_info.get('level')*100000)
        # print rank_value, '=============guild rank value'
        # rank_helper.add_rank_info('GuildLevel', guild_info.get('id'), rank_value)

        player.guild.g_id = guild_info.get('id')
        player.guild.exit_time = 1
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
                    player.base_info.level, icon_id)
    # hook task
    hook_task(player, CONDITIONId.JOIN_GUILD, 1)
    return response.SerializeToString()


def add_guild_rank(guild_id, guild_level):
    rank_value = (99999-guild_id) + (guild_level*100000)
    print rank_value, '=============guild rank value'
    rank_helper.add_rank_info('GuildLevel', guild_id, rank_value)


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
    tlog_action.log('JoinGuild', player, g_id)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def exit_guild_803(data, player):
    """退出公会 """
    p_id = player.base_info.id
    dynamicid = player.dynamic_id
    response = ExitGuildResponse()
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].exit_guild_remote(g_id, p_id, player.base_info.base_name)
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
        del_apply_cache(remote_res.get('apply_ids'), g_id)
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

    send_mail(conf_id=mail_id, receive_id=p_id,
              guild_name=remote_res.get('guild_name'))

    player.guild.exit_guild()
    player.guild.save_data()
    clear_related_data(player.base_info.id)

    response.res.result = True
    tlog_action.log('ExitGuild', player, g_id)
    return response.SerializeToString()


def del_apply_cache(apply_ids, g_id):
    for p_id in apply_ids:
        if not netforwarding.push_message('del_apply_cache_remote',
                                          p_id, g_id):
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
        remote_gate.push_object_remote(1815,
                                       proto_data.SerializeToString(),
                                       [player.dynamic_id])
    elif data['cmd'] == 'mine_help':
        print player.base_info.id, '========================'
        remote_gate.push_object_remote(877,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'be_mobai':
        player.guild.be_mobai()
        player.guild.save_data()
    elif data['cmd'] == 'deal_apply':
        if player.guild.g_id != 0:
            return 0
        remote_gate.login_guild_chat_remote(player.dynamic_id,
                                            data['guild_id'])
        player.guild.g_id = data['guild_id']
        player.guild.contribution = 0
        player.guild.all_contribution = 0
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
        player.guild.exit_guild()
        player.guild.save_data()
        remote_gate.push_object_remote(814,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'join_guild':
        remote_gate.push_object_remote(850,
                                       u'',
                                       [player.dynamic_id])
    elif data['cmd'] == 'canjoinguild':
        if is_not_open(player, FO_GUILD):
            return 0
        else:
            return 1
    return 1


@remoteserviceHandle('gate')
def editor_call_804(data, player):
    """编辑公告 """
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

    g_id = player.guild.g_id
    remote_res = remote_gate['world'].editor_call_remote(g_id,
                                                         player.base_info.id,
                                                         call)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    response.res.result = True
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
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    if res_type == 1:
        for p_id in p_ids:
            data = {'guild_id': player.guild.g_id,
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
                            p_id, res_type)

    else:
        if res_type == 3:
            for p_id in p_ids:
                tlog_action.log('DealJoinGuild', player, g_id,
                                p_id, res_type)
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

    remote_gate['world'].deal_apply_remote(g_id, p_ids,
                                           res_type)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def change_president_806(data, player):
    """转让会长 """
    dynamicid = player.dynamic_id
    p_id = player.base_info.id
    args = ChangePresidentRequest()
    args.ParseFromString(data)
    response = ChangePresidentResponse()
    target_id = args.p_id
    g_id = player.guild.g_id
    remote_res = remote_gate['world'].guild_change_president_remote(g_id, p_id,
                                                                    target_id,
                                                                    player.base_info.base_name)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    remote_gate.is_online_remote(
        'modify_user_guild_info_remote',
        target_id, {'cmd': 'change_president', 'position': 1})

    send_mail(conf_id=307, receive_id=target_id,
              guild_name=remote_res.get('name'))

    response.res.result = True
    tlog_action.log('GuildChangePresident', player, g_id, target_id)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def kick_807(data, player):
    """踢人 """
    args = KickRequest()
    args.ParseFromString(data)
    response = KickResponse()
    p_ids = args.p_ids
    g_id = player.guild.g_id
    be_kick_ids = []
    for a in p_ids:
        be_kick_ids.append(a)

    remote_res = remote_gate['world'].guild_kick_remote(g_id,
                                                        player.base_info.id,
                                                        be_kick_ids)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()
    kick_list = remote_res.get('kick_list')

    for be_kick_id in kick_list:
        data = {'guild_id': 0,
                'apply_guilds': []}
        is_online = remote_gate.is_online_remote(
            'modify_user_guild_info_remote', be_kick_id, {'cmd': 'kick'})
        if is_online == "notonline":
            p_guild_obj = tb_character_info.getObj(be_kick_id)
            mobai_info = p_guild_obj.hget('guild_mobai')
            mobai_info[0] = 0
            data['guild_mobai'] = mobai_info
            p_guild_obj.hmset(data)

        send_mail(conf_id=302, receive_id=be_kick_id,
                  guild_name=remote_res.get('name'))

        clear_related_data(be_kick_id)
        tlog_action.log('GuildKick', player, g_id, be_kick_id)

    response.res.result = True
    return response.SerializeToString()

def clear_related_data(player_id):
    """如果玩家退出军团，或者被踢, 删除此工会相关信息"""
    push_message("clear_related_data_remote", player_id)

@remoteserviceHandle('gate')
def clear_related_data_remote(is_online, player):
    """
    解散工会清除相关数据
    """
    player.escort_component.reset()
    player.escort_component.save_data()

@remoteserviceHandle('gate')
def bless_809(data, player):
    """祈福 """
    args = BlessRequest()
    args.ParseFromString(data)
    response = BlessResponse()
    bless_type = args.bless_type

    g_id = player.guild.g_id

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 'build', 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    build_info = remote_res.get('build')
    # {祈福编号：[资源类型,资源消耗量,建设值,福运,获得个人贡献值,圣兽召唤石数量]}
    # worship_info = game_configs.base_config.get('worship').get(bless_type)
    build_level = build_info.get(2)
    build_conf = game_configs.guild_config.get(2)[build_level]
    worship_info = build_conf.guild_worship.get(bless_type)

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

    remote_res = remote_gate['world'].bless_remote(g_id,
                                                   player.base_info.id,
                                                   bless_type,
                                                   player.base_info.base_name,
                                                   player.guild.bless_times)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    # 根据膜拜类型判断减什么钱，然后扣除
    if worship_info[0] == 1:  # 1金币  2元宝
        player.finance.coin -= worship_info[1]
    else:
        player.finance.consume_gold(worship_info[1], const.GUILD_BLESS)
    # 逻辑
    player.guild.do_bless(worship_info[4])
    guild_contribution = game_configs.base_config.get('guildContribution')
    animal_open_consume = game_configs.base_config.get('AnimalOpenConsume')

    return_data = gain(player, guild_contribution, const.Bless,
                       multiple=worship_info[4])  # 获取
    return_data = gain(player, animal_open_consume, const.Bless,
                       multiple=worship_info[5])  # 获取

    # rank_helper.add_rank_info('GuildLevel',
    #                           guild_obj.g_id, guild_obj.level)

    player.guild.save_data()
    player.finance.save_data()

    response.res.result = True
    # response.message = "膜拜成功"
    tlog_action.log('GuildWorship', player, g_id, bless_type, player.guild.bless_times)
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
    print response, '====================guild rank'
    response.res.result = True
    return response.SerializeToString()


def deal_rank_response_info(player, response, g_id, rank_num, rank_type=1):

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 0, 0)
    if not remote_res.get('result'):
        return False
    guild_info = remote_res.get('guild_info')

    if rank_type == 2 and guild_info.get('p_num') >= \
            game_configs.guild_config.get(1).get(guild_info.get('build')[1]).p_max:
        return False
    guild_rank = response.guild_rank.add()
    guild_rank.g_id = guild_info.get('id')
    guild_rank.rank = rank_num
    guild_rank.name = guild_info.get('name')
    guild_rank.level = guild_info.get('level')
    guild_rank.icon_id = guild_info.get('icon_id')
    guild_rank.ysdt_level = guild_info.get('build')[1]

    president_id = guild_info.get('p_list').get(1)[0]
    char_obj = tb_character_info.getObj(president_id)
    if char_obj.exists():
        guild_rank.president = char_obj.hget('nickname')
    else:
        guild_rank.president = u'错误'
        logger.error('guild rank, president player not fond,id:%s',
                     president_id)

    guild_rank.p_num = guild_info.get('p_num')
    guild_rank.call = guild_info.get('call')
    if player.base_info.id in guild_info.get('apply'):
        guild_rank.be_apply = 1
    else:
        guild_rank.be_apply = 0
    return True


@remoteserviceHandle('gate')
def get_role_list_811(data, player):
    """角色列表 """
    response = GetGuildMemberListResponse()
    g_id = player.guild.g_id
    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 0, 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    guild_info = remote_res.get('guild_info')

    guild_p_list = guild_info.get('p_list')
    for position, p_list in guild_p_list.items():
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

            role_info.position = position
            role_info.all_contribution = \
                character_info['all_contribution']
            role_info.contribution = character_info['contribution']
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
            role_info.day_contribution = today_contribution
            if role_id in player.guild.mobai_list:
                role_info.be_mobai = 1
            else:
                role_info.be_mobai = 0

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_info_812(data, player):
    """获取公会信息 """
    response = GetGuildInfoResponse()
    g_id = player.guild.g_id
    if not g_id:
        response.res.result = False
        response.res.result_no = 844
        return response.SerializeToString()

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 0, player.base_info.id)
    print '=================================112'
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    guild_info = remote_res.get('guild_info')

    position = remote_res.get('position')
    response.g_id = guild_info.get('id')
    response.name = guild_info.get('name')
    response.member_num = guild_info.get('p_num')
    response.contribution = guild_info.get('contribution')
    response.all_contribution = guild_info.get('all_contribution')
    response.icon_id = guild_info.get('icon_id')
    response.call = guild_info.get('call')
    response.level = guild_info.get('level')
    response.position = position
    response.all_zan_num = guild_info.get('praise_num')
    response.zan_money = guild_info.get('praise_money')
    for build_type, build_level in guild_info.get('build').items():
        build_info_pb = response.build_info.add()
        build_info_pb.build_type = build_type
        build_info_pb.build_level = build_level

    response.my_contribution = player.guild.contribution
    response.my_all_contribution = player.guild.all_contribution
    response.my_day_contribution = player.guild.today_contribution

    response.last_zan_time = player.guild.praise_time
    response.zan_num = player.guild.praise_num

    response.luck_num = guild_info.get('bless_luck_num')
    response.bless_num = player.guild.bless_times
    response.guild_bless_times = guild_info.get('bless_num')

    for bless_gift_no in player.guild.bless_gifts:
        response.bless_gift.append(bless_gift_no)
    rank_no = rank_helper.get_rank_by_key('GuildLevel',
                                          g_id)
    response.my_guild_rank = rank_no
    if position == 1:
        response.captain_name = player.base_info.base_name
        response.captain_id = player.base_info.id
        response.captain_level = player.base_info.level
        response.captain_power = int(player.line_up_component.combat_power)
        response.captain_vip_level = player.base_info.vip_level
        response.captain_icon = player.base_info.head

    else:
        president_id = guild_info.get('p_list').get(1)[0]
        character_info = tb_character_info.getObj(president_id).hgetall()
        if character_info:
            response.captain_name = character_info['nickname']
            response.captain_id = president_id
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
        if guild_info.get('apply'):
            response.have_apply = 1
        else:
            response.have_apply = 0
    response.be_mobai_times = player.guild.be_mobai_times
    response.mobai_times = player.guild.mobai_times

    for skill_type, skill_level in guild_info.get('guild_skills').items():
        skill_pb = response.guild_skill.add()
        skill_pb.skill_type = skill_type
        skill_pb.skill_level = skill_level
    response.skill_point = guild_info.get('skill_point')

    # hook task
    hook_task(player, CONDITIONId.JOIN_GUILD, 1)

    response.res.result = True
    print response, '===========guild info'
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_apply_list_813(data, player):
    """获取申请列表 """
    response = GetApplyListResponse()
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 0, 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    guild_info = remote_res.get('guild_info')

    guild_apply = guild_info.get('apply')

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
def invite_join_1803(data, player):
    """邀请加入军团 """
    args = InviteJoinRequest()
    args.ParseFromString(data)
    response = InviteJoinResponse()
    target_id = args.user_id
    g_id = player.guild.g_id

    info = tb_character_info.getObj(target_id).hget('guild_id')
    if info != 0:
        response.res.result = False
        # response.res.message = "对方已有军团"
        response.res.result_no = 865
        return response.SerializeToString()

    remote_res = remote_gate['world'].invite_join_guild_remote(g_id, player.base_info.id, target_id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    is_online = remote_gate.is_online_remote('modify_user_guild_info_remote',
                                             target_id,
                                             {'cmd': 'canjoinguild'})
    if is_online == "notonline":
        character_obj = tb_character_info.getObj(target_id)
        if not character_obj.exists():
            response.res.result = False
            response.res.result_no = 800
            logger.error('invite join ,target id error')
            return response.SerializeToString()
        level = character_obj.hget('level')
        feature_item = game_configs.features_open_config.get(FO_GUILD)
        if feature_item.open > level:
            response.res.result = False
            # "对方未开启军团功能"
            response.res.result_no = 866
            return response.SerializeToString()

    elif is_online == 0:
        response.res.result = False
        # "对方未开启军团功能"
        response.res.result_no = 866
        return response.SerializeToString()

    mail_id = game_configs.base_config.get('guildInviteMail')
    send_mail(conf_id=mail_id, receive_id=target_id,
              guild_name=remote_res.get('name'),
              guild_p_num=remote_res.get('p_num'),
              guild_level=remote_res.get('level'),
              guild_id=g_id, nickname=player.base_info.base_name)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def deal_invite_join_1804(data, player):
    """处理邀请加入军团 """
    args = DealInviteJoinRequest()
    args.ParseFromString(data)
    response = DealInviteJoinResResponse()
    g_id = args.guild_id
    res = args.res
    response.res.result = True

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
        if player.guild.g_id != 0:
            response.res.result = False
            response.res.result_no = 843
            #response.message = "你已经有军团了"
            return response.SerializeToString()

    remote_res = remote_gate['world'].deal_invite_guild_remote(g_id, player.base_info.id, res,
                                                               player.base_info.base_name)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    player.mail_component.delete_mails([args.mail_id])

    if res:
        player.guild.g_id = g_id
        player.guild.save_data()
        remote_gate.login_guild_chat_remote(player.dynamic_id,
                                            player.guild.g_id)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def praise_1807(data, player):
    """点赞 """
    response = ZanResResponse()
    g_id = player.guild.g_id

    praise_num_max = game_configs.base_config.get('worShipFrequencyMax')
    praise_cooling_time = game_configs.base_config.get('worShipCoolingTime')
    if player.guild.praise_num >= praise_num_max:
        #  "次数不够"
        response.res.result = False
        response.res.result_no = 851
        return response.SerializeToString()
    if player.guild.praise_time+praise_cooling_time >= time.time():
        #  "冷却"
        response.res.result = False
        response.res.result_no = 889
        return response.SerializeToString()

    this_times = player.guild.praise_num+1
    remote_res = remote_gate['world'].praise_remote(g_id,
                                                    player.base_info.id,
                                                    player.base_info.base_name,
                                                    this_times)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    build_level = remote_res.get('build_level')
    build_config = game_configs.guild_config.get(1).get(build_level)

    player.guild.add_praise_times()

    dorp_item = parse({107: [remote_res.get('drop_num'), remote_res.get('drop_num'),
                      build_config.worShip[this_times][2]]})
    return_data = gain(player, dorp_item, const.PraiseGift)  # 获取
    get_return(player, return_data, response.gain)
    player.guild.save_data()

    response.zan_money = remote_res.get('money_num')
    response.all_zan_num = remote_res.get('praise_times')
    response.last_zan_time = player.guild.praise_time

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def captailn_receive_1806(data, player):
    """团长领取赞的奖励 """
    response = ReceiveResponse()
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].captailn_receive_remote(g_id,
                                                              player.base_info.id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    build_level = remote_res.get('build_level')
    build_config = game_configs.guild_config.get(1).get(build_level)
    money_num = remote_res.get('money_num')

    dorp_item = parse({107: [money_num, money_num,
                      build_config.headSworShip[2]]})

    return_data = gain(player, dorp_item, const.ReceivePraiseGift)  # 获取
    get_return(player, return_data, response.gain)
    tlog_action.log('CaptainReceiveZan', player, player.guild.g_id,
                    money_num, remote_res.get('praise_times'))

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_bless_gift_1808(data, player):
    """领取祈福的奖励 """
    args = GetBlessGiftRequest()
    args.ParseFromString(data)
    response = GetBlessGiftResponse()
    gift_no = args.gift_no
    g_id = player.guild.g_id

    if gift_no in player.guild.bless_gifts:
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 0, 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    guild_info = remote_res.get('guild_info')

    build_level = guild_info.get('build').get(2)
    build_conf = game_configs.guild_config.get(2)[build_level]
    gift_info = build_conf.reward.get(gift_no)

    if not gift_info:
        response.res.result = False
        response.res.result_no = 855
        return response.SerializeToString()

    if guild_info.get('bless_luck_num') < gift_info[0]:
        response.res.result = False
        response.res.result_no = 856
        return response.SerializeToString()

    prize = parse({106: [1, 1, gift_info[1]]})
    return_data = gain(player, prize, const.ReceiveBlessGift)  # 获取
    get_return(player, return_data, response.gain)

    player.guild.receive_bless_gift(gift_no)
    player.guild.save_data()
    tlog_action.log('GuildWorshipGift', player, g_id, build_level, gift_no)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def find_guild_1809(data, player):
    """搜索军团 """
    args = FindGuildRequest()
    args.ParseFromString(data)
    response = FindGuildResponse()
    id_or_name = args.id_or_name

    if not id_or_name.isdigit():
        guild_name_obj = tb_guild_info.getObj('names')
        isexist = guild_name_obj.hexists(id_or_name)

    remote_res = remote_gate['world'].get_guild_info_remote(id_or_name, 0, 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    guild_info = remote_res.get('guild_info')

    rank_no = rank_helper.get_rank_by_key('GuildLevel',
                                          guild_info.get('id'))

    guild_rank = response.guild_info
    guild_rank.g_id = guild_info.get('id')
    guild_rank.rank = rank_no
    guild_rank.name = guild_info.get('name')
    guild_rank.level = guild_info.get('level')
    guild_rank.icon_id = guild_info.get('icon_id')

    president_id = guild_info.get('p_list').get(1)[0]
    char_obj = tb_character_info.getObj(president_id)
    if char_obj.exists():
        guild_rank.president = char_obj.hget('nickname')
    else:
        guild_rank.president = u'错误'
        logger.error('guild rank, president player not fond,id:%s',
                     president_id)

    guild_rank.p_num = guild_info.get('p_num')
    guild_rank.call = guild_info.get('call')
    if player.base_info.id in guild_info.get('apply'):
        guild_rank.be_apply = 1
    else:
        guild_rank.be_apply = 0

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def appoint_1810(data, player):
    """任命 """
    args = AppointRequest()
    args.ParseFromString(data)
    response = AppointResponse()
    deal_type = args.deal_type
    target_id = args.p_id

    g_id = player.guild.g_id
    remote_res = remote_gate['world'].guild_appoint_remote(g_id, player.base_info.id, deal_type, target_id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    if deal_type == 1:
        mail_id = 306
        now_positon = 2
    else:  # deal type == 2
        mail_id = 308
        now_positon = 3
    remote_gate.is_online_remote(
        'modify_user_guild_info_remote', target_id,
        {'cmd': 'change_president', "position": now_positon})

    send_mail(conf_id=mail_id, receive_id=target_id,
              guild_name=remote_res.get('name'))
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

    remote_res = remote_gate['world'].up_build_remote(g_id, p_id,
                                                      build_type)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()
    # rank_value = (99999-g_id) + (remote_res.get('level')*100000)
    # print rank_value, '=============guild rank value'
    # rank_helper.add_rank_info('GuildLevel', g_id, rank_value)

    add_guild_rank(g_id, remote_res.get('level'))
    response.res.result = True
    tlog_action.log('GuildBuildUp', player, player.guild.g_id,
                    remote_res.get('build_level'),
                    build_type)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def mobai_871(data, player):
    args = GuildMOBAIRequest()
    args.ParseFromString(data)
    u_id = args.u_id
    response = GuildMOBAIResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    mobai_list = player.guild.mobai_list
    if u_id in mobai_list:
        logger.error('mobai, yijing mobaiguo')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()
    character_obj = tb_character_info.getObj(u_id)
    character_info = character_obj.hmget(['attackPoint', 'guild_mobai'])
    if not character_info:
        logger.error('mobai, uid error')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()
    u_power = character_info['attackPoint']
    if player.line_up_component.combat_power > u_power:
        response.res.result = False
        response.res.result_no = 892
        return response.SerializeToString()
    if len(mobai_list) >= game_configs.base_config.get('Worship2FrequencyMax'):
        response.res.result = False
        response.res.result_no = 851
        return response.SerializeToString()

    remote_res = remote_gate['world'].mobai_remote(g_id, p_id,
                                                   u_id, player.base_info.base_name)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()

    player.guild.do_mobai(u_id)
    return_data = gain(player, game_configs.base_config.get('Worship2'),
                       const.GUILD_MOBAI)  # 获取
    get_return(player, return_data, response.gain)

    data = {'position': 1}
    is_online = remote_gate.is_online_remote(
        'modify_user_guild_info_remote',
        u_id, {'cmd': 'be_mobai'})

    if is_online == "notonline":
        p_mobai_info = character_info['guild_mobai']
        if time.localtime(p_mobai_info[2]).tm_yday != time.localtime().tm_yday:
            data = {'guild_mobai': [0, [p_id], int(time.time())]}
        else:
            p_mobai_info[1].append(p_id)
            data = {'guild_mobai': p_mobai_info}
        character_obj.hmset(data)

    player.guild.save_data()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def receive_mobai_872(data, player):
    response = ReceiveMOBAIResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    if g_id == 0:
        # "没有公会"
        logger.error('mobai, guild id == 0')
        response.res.result = False
        response.res.result_no = 846
        return response.SerializeToString()
    be_mobai_times = player.guild.be_mobai_times
    if not be_mobai_times:
        logger.error('mobai, be_mobai_times == 0')
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    player.guild.receive_mobai()
    return_data = gain(player, game_configs.base_config.get('AreWorship2'),
                       const.GUILD_MOBAI, multiple=be_mobai_times)  # 获取
    get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def mine_seek_help_873(data, player):
    # 秘境求助
    args = MineSeekHelpRequest()
    args.ParseFromString(data)
    pos = args.pos                    # 矿所在位置
    response = MineSeekHelpResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    if g_id == 0:
        # "没有公会"
        response.res.result = False
        response.res.result_no = 846
        return response.SerializeToString()

    res = player.mine.seek_help(pos)
    if not res.get('res'):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()
    # 推动消息给所有玩家
    for plist in res.get('p_list').values():
        for target_id in plist:
            if target_id == p_id:
                continue
            remote_gate.is_online_remote(
                'modify_user_guild_info_remote',
                target_id, {'cmd': 'mine_help'})

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def mine_seek_help_list_874(data, player):
    # 秘境求助列表
    response = MineSeekHelpListResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].mine_seek_help_list_remote(g_id, p_id)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()
    mine_help_list = remote_res.get('mine_help_list')
    p_list = remote_res.get('p_list')
    for _time, [mine_id, u_id, times] in mine_help_list.items():
        # if u_id == p_id:
        #     continue
        if _time in player.guild.mine_help:
            continue
        character_obj = tb_character_info.getObj(u_id)
        if not character_obj.exists():
            continue
        character_info = character_obj.hmget(['nickname', 'heads', 'level',
                                              'vip_level'])

        help_info = response.help_infos.add()
        help_info.p_id = u_id
        help_info.name = character_info['nickname']
        help_info.level = character_info['level']
        help_info.vip_level = character_info['vip_level']

        heads = Heads_DB()
        heads.ParseFromString(character_info['heads'])
        help_info.icon = heads.now_head
        help_info.mine_id = mine_id
        help_info.seek_time = _time
        help_info.be_help_times = times
        position = 1
        for _position, _list in p_list.items():
            if u_id in _list:
                position = _position
                break
        help_info.position = position

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def mine_help_list_875(data, player):
    # 秘境帮助
    args = MineHelpRequest()
    args.ParseFromString(data)
    seek_time = args.seek_time                    # 矿所在位置
    response = MineHelpResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].mine_help_remote(g_id, p_id, seek_time, player.guild.mine_help)
    if not remote_res.get('res'):
        response.res.result = False
        response.res.result_no = remote_res.get('no')
        return response.SerializeToString()
    help_ids = remote_res.get('help_ids')
    player.guild.mine_help = help_ids
    player.guild.save_data()

    tlog_action.log('MineHelp', player, player.guild.g_id,
                    str(remote_res.get('uids')))

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_dynamics_876(data, player):
    # 获取军团动态
    response = GuildDynamicsResponse()

    p_id = player.base_info.id
    g_id = player.guild.g_id

    remote_res = remote_gate['world'].get_guild_info_remote(g_id, 'dynamics', 0)
    if not remote_res.get('result'):
        response.res.result = False
        response.res.result_no = remote_res.get('result_no')
        return response.SerializeToString()
    dynamics = remote_res.get('dynamics')
    for dynamic in dynamics:
        _dynamic = GuildDynamic()
        dynamic_pb = response.dynamics.add()
        _dynamic.ParseFromString(dynamic)
        dynamic_pb.CopyFrom(_dynamic)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_guild_contribution_880(data, player):
    """
    获取军团建设值
    """
    response = GetGuildContributionResponse()
    res = remote_gate["world"].get_guild_info_remote(player.guild.g_id, "contribution", 0)
    response.contribution = res.get("contribution", 0)
    res = remote_gate["world"].get_guild_info_remote(player.guild.g_id, "all_contribution", 0)
    response.all_contribution = res.get("all_contribution", 0)
    logger.debug(response)

    return response.SerializeToString()
