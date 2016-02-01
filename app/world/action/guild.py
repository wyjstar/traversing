# -*- coding:utf-8 -*-
"""
created by cui
"""
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
import time
import cPickle
from app.world.core.guild_manager import guild_manager_obj
from shared.db_opear.configs_data import game_configs
import random
from app.world.action import mine
from shared.common_logic.shop import do_shop_buy
from shared.utils import trie_tree
from app.proto_file import guild_pb2
from shared.utils.const import const

tb_guild_info = RedisObject('tb_guild_info')
tb_character_info = RedisObject('tb_character_info')


@rootserviceHandle
def create_guild_remote(p_id, g_name, icon_id, apply_guilds):
    """
    """
    res = {}
    # 判断有没有重名
    guild_name_data = tb_guild_info.getObj('names')
    _result = guild_name_data.hget(g_name)
    if _result:
        return {'res': False}

    guild_obj = guild_manager_obj.create_guild(p_id, g_name, icon_id)
    guild_name_data.hmset({g_name: guild_obj.g_id})
    del_player_apply(p_id, apply_guilds)

    return {'res': True, 'guild_info': guild_obj.guild_data}


@rootserviceHandle
def get_guild_info_remote(guild_id, info_name, p_id):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(guild_id)
    if not guild_obj:
        return {'result': False, 'result_no': 844}
    res = {}
    if info_name:
        res.update({'result': True, info_name: getattr(guild_obj, info_name)})
    else:
        res.update({'result': True, 'guild_info': guild_obj.guild_data})
    if p_id:
        res.update(dict(position=guild_obj.get_position(p_id)))
    logger.debug("get_guild_info: %s" % res)
    return res


@rootserviceHandle
def deal_invite_guild_remote(g_id, p_id, res, name):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    if not guild_obj.invite_join.get(p_id):
        return {'res': False, 'no': 800}
    del guild_obj.invite_join[p_id]
    if res:
        p_max = game_configs.guild_config.get(1).get(guild_obj.build.get(1)).p_max
        if not guild_obj.invite_join.get(p_id) and guild_obj.p_num+1 > p_max:
            return {'res': False, 'no': 845}
        p_list3 = guild_obj.p_list.get(3, [])
        if p_list3:
            p_list3.append(p_id)
        else:
            guild_obj.p_list[3] = [p_id]

        dynamic_pb = guild_pb2.GuildDynamic()
        dynamic_pb.type = const.DYNAMIC_JOIN
        dynamic_pb.time = int(time.time())
        dynamic_pb.name1 = name

        guild_obj.add_dynamic(dynamic_pb.SerializeToString())

    guild_obj.save_data()

    return {'res': True}


@rootserviceHandle
def invite_join_guild_remote(g_id, p_id, target_id):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    position = guild_obj.get_position(p_id)
    if position > 2:
        # 没有权限
        return {'res': False, 'no': 849}
    now = int(time.time())
    for _p_id, i_time in guild_obj.invite_join.items():
        if i_time + game_configs.base_config.get('guildInviteTime') > now:
            del guild_obj.invite_join[_p_id]
    p_max = game_configs.guild_config.get(1).get(guild_obj.build.get(1)).p_max
    if not guild_obj.invite_join.get(target_id) and guild_obj.p_num+1 > p_max:
        return {'res': False, 'no': 845}

    guild_obj.invite_join[target_id] = now
    guild_obj.save_data()

    return {'res': True, 'name': guild_obj.name, 'level': guild_obj.level,
            'p_num': guild_obj.p_num}


@rootserviceHandle
def guild_change_president_remote(g_id, p_id, target_id, name):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    position = guild_obj.get_position(p_id)
    if position != 1:
        # 没有权限
        return {'res': False, 'no': 849}
    flag = 0
    for pos, p_list in guild_obj.p_list.items():
        if pos == 1:
            continue
        if target_id in p_list:
            p_list.remove(target_id)
            guild_obj.p_list[1] = [target_id]
            flag = 1
    if not flag:
        return {'res': False, 'no': 850}
    p_list3 = guild_obj.p_list.get(3, [])
    if p_list3:
        p_list3.append(p_id)
    else:
        guild_obj.p_list[3] = [p_id]

    dynamic_pb = guild_pb2.GuildDynamic()
    dynamic_pb.type = const.DYNAMIC_CHANGE
    dynamic_pb.time = int(time.time())
    name2 = tb_character_info.getObj(target_id).hget('nickname')
    dynamic_pb.name1 = name
    dynamic_pb.name2 = name2

    guild_obj.add_dynamic(dynamic_pb.SerializeToString())
    guild_obj.save_data()
    return {'res': True, 'name': guild_obj.name}


@rootserviceHandle
def editor_call_remote(g_id, p_id, call):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    position = guild_obj.get_position(p_id)
    if not position or position > 2:
        # 没有权限
        return {'res': False, 'no': 849}
    new_call = ''
    if call:
        new_call = trie_tree.check.replace_bad_word(call)
    guild_obj.editor_call(new_call)

    guild_obj.save_data()
    return {'res': True, 'name': guild_obj.name}


@rootserviceHandle
def guild_appoint_remote(g_id, p_id, deal_type, target_id):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    position = guild_obj.get_position(p_id)
    if position != 1:
        # 没有权限
        return {'res': False, 'no': 849}
    p_list2 = guild_obj.p_list.get(2, [])
    p_list3 = guild_obj.p_list.get(3, [])

    dynamic_pb = guild_pb2.GuildDynamic()

    if deal_type == 1:  # 1提拔2撤销
        dynamic_pb.type = const.DYNAMIC_UP
        if len(p_list2) >= 2:
            return {'res': False, 'no': 860}
        if target_id not in p_list3:
            return {'res': False, 'no': 800}
        p_list3.remove(target_id)
        if p_list2:
            p_list2.append(target_id)
        else:
            guild_obj.p_list[2] = [target_id]
    else:
        dynamic_pb.type = const.DYNAMIC_DOWN
        if target_id not in p_list2:
            return {'res': False, 'no': 800}
        p_list2.remove(target_id)
        if p_list3:
            p_list3.append(target_id)
        else:
            guild_obj.p_list[3] = [target_id]

    dynamic_pb.time = int(time.time())
    name = tb_character_info.getObj(target_id).hget('nickname')
    dynamic_pb.name1 = name
    guild_obj.add_dynamic(dynamic_pb.SerializeToString())

    guild_obj.save_data()
    return {'res': True, 'name': guild_obj.name}


@rootserviceHandle
def guild_kick_remote(g_id, p_id, be_kick_ids):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    position = guild_obj.get_position(p_id)
    kick_list = []
    p_ids = []
    for _, x in guild_obj.p_list.items():
        p_ids += x
    if not position or position > 2:
        # 没有权限 或者 不在此军团
        return {'res': False, 'no': 849}

    p_list2 = guild_obj.p_list.get(2, [])
    p_list3 = guild_obj.p_list.get(3, [])
    for be_kick_id in be_kick_ids:
        if be_kick_id in p_list2 and position == 1:
            guild_obj.p_list[2].remove(be_kick_id)
        elif be_kick_id in p_list3:
            guild_obj.p_list[3].remove(be_kick_id)
        else:
            continue
        kick_list.append(be_kick_id)

        dynamic_pb = guild_pb2.GuildDynamic()
        dynamic_pb.time = int(time.time())
        dynamic_pb.type = const.DYNAMIC_KICK
        name = tb_character_info.getObj(be_kick_id).hget('nickname')
        dynamic_pb.name1 = name
        guild_obj.add_dynamic(dynamic_pb.SerializeToString())

    guild_obj.save_data()
    return {'res': True, 'kick_list': kick_list, 'name': guild_obj.name}


@rootserviceHandle
def join_guild_remote(g_id, p_id):
    """
    no 844 id error 859 申请人数满 845 成员已经满
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('join_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    if len(guild_obj.apply) >= game_configs.base_config. \
            get('guildApplyMaxNum'):
        # "军团申请人数已满
        return {'res': False, 'no': 859}
    if guild_obj.p_num >= game_configs.guild_config. \
            get(1).get(guild_obj.build[1]).p_max:
        # "公会已满员"
        return {'res': False, 'no': 845}

    guild_obj.join_guild(p_id)
    guild_obj.save_data()
    return {'res': True, 'captain_id': guild_obj.p_list.get(1)[0]}


@rootserviceHandle
def exit_guild_remote(guild_id, p_id, name):
    """
    no: True 1 解散公会 2 团长退出 3 非团长退出
    """
    guild_obj = guild_manager_obj.get_guild_obj(guild_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if not position:
        # "您不在此公会"
        return {'res': False, 'no': 850}
    p_num = guild_obj.p_num
    if p_num == 1:
        # 删名字
        guild_name_data = tb_guild_info.getObj('names')
        if guild_name_data.hget(guild_obj.name):
            guild_name_data.hdel(guild_obj.name)
        # 删军团
        guild_manager_obj.delete_guild(guild_obj.g_id)
        return {'res': True, 'no': 1,
                'apply_ids': guild_obj.apply,
                'guild_name': guild_obj.name}
    if position == 1:
        p_list = []
        next_position = 0
        no = 2
        if guild_obj.p_list.get(2):
            next_position = 2
            p_list = guild_obj.p_list.get(2)
        else:
            next_position = 3
            p_list = guild_obj.p_list.get(3)
        next_id = get_next_captain(p_list)
        guild_obj.change_position(next_id, next_position, position)
    else:
        no = 3
    guild_obj.exit_guild(p_id, position)

    dynamic_pb = guild_pb2.GuildDynamic()
    dynamic_pb.type = const.DYNAMIC_EXIT
    dynamic_pb.time = int(time.time())
    dynamic_pb.name1 = name
    guild_obj.add_dynamic(dynamic_pb.SerializeToString())

    guild_obj.save_data()
    return {'res': True, 'no': no,
            'apply_ids': guild_obj.apply,
            'guild_name': guild_obj.name}


def get_next_captain(p_list):
    p_datas = {}
    for p_id in p_list:
        character_obj = tb_character_info.getObj(p_id)
        if not character_obj.exists():
            continue
        character_data = character_obj.hmget(['attackPoint',
                                              'join_guild_time'])
        p_datas[p_id] = character_data
    new_list = sorted(p_datas.items(),
                      key=lambda x: (x[1]['attackPoint'],
                                     x[1]['join_guild_time']),
                      reverse=True)
    return new_list[0][0]


@rootserviceHandle
def cheak_deal_apply_remote(g_id, p_ids, p_id, deal_type):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if not position or position > 2:
        # 没有权限 或者 不在此军团
        return {'res': False, 'no': 800}

    if deal_type == 1:
        p_num = guild_obj.p_num
        p_max = game_configs.guild_config.get(1).get(guild_obj.build[1]).p_max
        if p_num+len(p_ids) > p_max:
            # "超出公会人数上限"
            return {'res': False, 'no': 845}

    return {'res': True,
            'guild_name': guild_obj.name,
            'applys': guild_obj.apply}


@rootserviceHandle
def deal_apply_remote(g_id, p_ids, deal_type):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if deal_type == 1:
        for p_id in p_ids:
            if p_id not in guild_obj.apply:
                continue

            guild_obj.apply.remove(p_id)
            if guild_obj.p_list.get(3):
                p_list1 = guild_obj.p_list.get(3)
                p_list1.append(p_id)
                # guild_obj.p_list.update({3: p_list1})
            else:
                # guild_obj.p_list.update({3: [p_id]})
                guild_obj.p_list[3] = [p_id]

            character_obj = tb_character_info.getObj(p_id)
            character_info = character_obj.hgetall()
            del_player_apply(p_id, character_info.get('apply_guilds', []))

            dynamic_pb = guild_pb2.GuildDynamic()
            dynamic_pb.type = const.DYNAMIC_JOIN
            dynamic_pb.time = int(time.time())
            dynamic_pb.name1 = character_info.get('nickname')
            guild_obj.add_dynamic(dynamic_pb.SerializeToString())
    if deal_type == 2:
        for p_id in p_ids:
            if p_id in guild_obj.apply:
                guild_obj.apply.remove(p_id)
    if deal_type == 3:
        guild_obj.apply = []
    guild_obj.save_data()


def del_player_apply(p_id, apply_guilds):
    for g_id in apply_guilds:
        guild_obj = guild_manager_obj.get_guild_obj(g_id)
        if not guild_obj:
            continue
        if p_id in guild_obj.apply:
            guild_obj.apply.remove(p_id)
            guild_obj.save_data()


@rootserviceHandle
def up_build_remote(g_id, p_id, build_type):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if position != 1:
        # 没有权限 或者 不在此军团
        return {'res': False, 'no': 800}

    build_info = guild_obj.build
    build_level = build_info.get(build_type)
    if not build_level:
        logger.error('up_build_870, build type error')
        return {'res': False, 'no': 891}
    build_conf = game_configs.guild_config.get(build_type)[build_level]
    if guild_obj.contribution < build_conf.exp:
        logger.error('up_build_870, build type error')
        return {'res': False, 'no': 888}

    if build_level >= game_configs.base_config.get('guild_level_max').get(build_type):
        logger.error('up_build_870, level max')
        return {'res': False, 'no': 800}

    for up_c in build_conf.condition:
        c_conf = game_configs.guild_config.get(up_c)
        my_build_level = build_info.get(c_conf.type)
        if not my_build_level or my_build_level < c_conf.level:
            logger.error('up_build_870, build type error')
            return {'res': False, 'no': 892}

    build_info[build_type] += 1
    guild_obj.build = build_info
    guild_obj.contribution -= build_conf.exp
    guild_obj.save_data()

    return {'res': True, 'build_level': guild_obj.build.get(build_type),
            'level': guild_obj.level}


@rootserviceHandle
def praise_remote(g_id, p_id, name, this_times):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    build_level = guild_obj.build.get(1)
    build_conf = game_configs.guild_config.get(1)[build_level]

    headSworShip = build_conf.headSworShip
    worShip = build_conf.worShip
    money_num = random.randint(headSworShip[0], headSworShip[1])
    drop_num = random.randint(worShip[this_times][0], worShip[this_times][1])
    guild_obj.add_praise_money(money_num)

    dynamic_pb = guild_pb2.GuildDynamic()
    dynamic_pb.type = const.DYNAMIC_ZAN
    dynamic_pb.time = int(time.time())
    dynamic_pb.name1 = name
    dynamic_pb.num1 = drop_num

    guild_obj.add_dynamic(dynamic_pb.SerializeToString())
    guild_obj.save_data()
    return {'res': True, 'build_level': build_level,
            'money_num': guild_obj.praise_money,
            'praise_times': guild_obj.praise_num,
            'drop_num': drop_num}


@rootserviceHandle
def captailn_receive_remote(g_id, p_id):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if position != 1:
        # 没有权限 或者 不在此军团
        return {'res': False, 'no': 800}

    build_level = guild_obj.build.get(1)
    build_conf = game_configs.guild_config.get(1)[build_level]

    money_num = guild_obj.praise_money
    if guild_obj.praise_money <= 0:
        return {'res': False, 'no': 800}

    guild_obj.receive_praise_money()
    guild_obj.save_data()
    return {'res': True, 'build_level': build_level,
            'money_num': money_num, 'praise_times':
            guild_obj.praise_num}


@rootserviceHandle
def bless_remote(g_id, p_id, bless_type, name, my_bless_times):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    build_level = guild_obj.build.get(2)
    build_conf = game_configs.guild_config.get(2)[build_level]
    worship_info = build_conf.guild_worship.get(bless_type)

    dynamic_pb = guild_pb2.GuildDynamic()
    dynamic_pb.type = const.DYNAMIC_BLESS
    dynamic_pb.time = int(time.time())
    dynamic_pb.name1 = name
    dynamic_pb.num1 = worship_info[2]

    guild_obj.add_dynamic(dynamic_pb.SerializeToString())

    guild_obj.do_bless(worship_info[2], worship_info[3], my_bless_times)
    guild_obj.save_data()

    return {'res': True}


@rootserviceHandle
def mobai_remote(g_id, p_id, u_id, name):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    p_list = guild_obj.p_list
    for _, _p_list in guild_obj.p_list.items():
        if u_id in _p_list:
            drop_num = game_configs.base_config.get('Worship2')[0].num
            dynamic_pb = guild_pb2.GuildDynamic()
            dynamic_pb.type = const.DYNAMIC_MOBAI
            dynamic_pb.time = int(time.time())
            dynamic_pb.name1 = name
            name2 = tb_character_info.getObj(u_id).hget('nickname')
            dynamic_pb.name2 = name2
            dynamic_pb.num1 = drop_num
            return {'res': True}

    logger.error('mobai, player dont in guild')
    return {'res': False, 'no': 800}


@rootserviceHandle
def mine_seek_help_remote(u_id, mine_id, g_id):
    """
    求助
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}

    if not mine.guild_seek_help(mine_id, u_id):
        return {'res': False, 'no': 800}

    mine_help = guild_obj.mine_help
    now = int(time.time())

    a = 1
    while mine_help.get(now):
        if a > 2:
            return {'res': False, 'no': 800}
        now += 1
        a += 1

    guild_obj.mine_help[now] = [mine_id, u_id, 0]
    guild_obj.save_data()
    return {'res': True, 'p_list': guild_obj.p_list}


@rootserviceHandle
def mine_seek_help_list_remote(g_id, p_id):
    """
    获取列表
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if not position:
        #  不在此军团
        return {'res': False, 'no': 800}

    p_ids = []
    for _, x in guild_obj.p_list.items():
        p_ids += x
    for _time, [mine_id, u_id, times] in guild_obj.mine_help.items():
        if u_id not in p_ids:
            del guild_obj.mine_help[_time]
            continue
        if not mine.check_guild_seek_help(mine_id, u_id):
            del guild_obj.mine_help[_time]
            continue

    return {'res': True, 'mine_help_list': guild_obj.mine_help,
            'p_list': guild_obj.p_list}


@rootserviceHandle
def mine_help_remote(g_id, p_id, seek_time, already_helps):
    """
    帮助加速
    此函数处理在帮助加速的的同时，更新玩家已经帮助列表
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 844}
    position = guild_obj.get_position(p_id)
    if not position:
        #  不在此军团
        return {'res': False, 'no': 800}

    build_level = guild_obj.build.get(1)
    build_conf = game_configs.guild_config.get(1)[build_level]
    shorten_time = build_conf.shortenTime

    help_ids = []
    p_ids = []  # 所有的成员ID
    uids = []
    for _, x in guild_obj.p_list.items():
        p_ids += x
    for _time, [mine_id, u_id, times] in guild_obj.mine_help.items():
        if u_id not in p_ids:
            del guild_obj.mine_help[_time]
            continue
        if u_id == p_id:
            continue
        if _time in already_helps:
            help_ids.append(_time)
            continue
        if seek_time and seek_time != _time:
            continue
        if not mine.guild_help(mine_id, u_id, p_id, shorten_time):
            del guild_obj.mine_help[_time]
        else:
            times += 1
            guild_obj.mine_help[_time] = [mine_id, u_id, times]
            help_ids.append(_time)
        uids.append(u_id)

    # help_ids 这次帮助的列表 加上 之前帮助的而且这个请求还存在的
    # already_helps 之前已经帮助过的列表
    # guild_obj.mine_help 军团里所有的请求
    return {'res': True, 'help_ids': help_ids, 'uids': uids}


@rootserviceHandle
def get_shop_data_remote(g_id, shop_type):
    """
    军团商店
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return None
    return guild_obj.get_shop_data(shop_type)


@rootserviceHandle
def guild_shop_buy_remote(g_id, shop_id, item_count, shop_type, vip_level):
    """
    """
    guild_obj = guild_manager_obj.get_guild_obj(g_id)
    if not guild_obj:
        logger.error('exit_guild_remote guild id error! pid:%d' % p_id)
        return {'res': False, 'no': 800}
    shop = guild_obj.get_shop_data(shop_type)
    if not shop:
        return {'res': False, 'no': 800}
    build_level = guild_obj.build.get(1)
    res = do_shop_buy(shop_id, item_count, shop, vip_level, build_level)
    if res.get('res'):
        guild_obj.save_data()
    return res
