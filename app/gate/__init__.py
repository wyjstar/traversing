#coding:utf8

import action
from gfirefly.server.logobj import logger
from app.gate.core.users_manager import UsersManager
from gtwisted.core import reactor
from gfirefly.server.globalobject import GlobalObject
from shared.utils.ranking import Ranking
from shared.tlog import tlog_action
from app.gate.redis_mode import tb_character_info
from shared.utils.const import const
import time


front_ip = GlobalObject().json_config['front_ip']
front_port = GlobalObject().json_config['front_port']
name = GlobalObject().json_config['name']


def tick():
    result = GlobalObject().remote['login'].server_sync_remote(name, front_ip,
                                                               front_port,
                                                               'recommend')
    if result is False:
        reactor.callLater(1, tick)
    else:
        reactor.callLater(60, tick)
    logger.info('server online num:%s', UsersManager().get_online_num())
    tlog_action.log('OnlineNum', UsersManager().get_online_num())

reactor.callLater(1, tick)
# 初始化工会排行
Ranking.init('GuildLevel', 9999)
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)


def add_level_rank_info(instance, users):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'attackPoint'])
        if character_info['attackPoint']:
            rank_value = int(character_info['attackPoint'])
        else:
            rank_value = 0
        value = character_info['level'] * const.level_rank_xs + rank_value
        instance.add(uid, value)  # 添加rank数据
        print 'level', value, rank_value, character_info['level'], uid


def add_power_rank_info(instance, users):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'attackPoint'])
        if character_info['attackPoint']:
            rank_value = int(character_info['attackPoint'])
        else:
            rank_value = 0
        value = rank_value * const.power_rank_xs + character_info['level']
        instance.add(uid, value)  # 添加rank数据
        print 'power', value, rank_value, character_info['level'], uid


def add_star_rank_info(instance, users):
    for uid in users:
        character_obj = tb_character_info.getObj(uid)
        character_info = character_obj.hmget(['level', 'stage_progress', 'star_num'])
        star_num_list = character_info['star_num']
        star_num = 0
        for x in star_num_list:
            star_num += x

        value = star_num * const.power_rank_xs + character_info['level']
        instance.add(uid, value)  # 添加rank数据
        data = {'rank_stage_progress': character_info['stage_progress']}
        character_obj.hmset(data)
        print 'star', value, star_num, character_info['level'], uid


def flag_doublu_day():
    """
    return 0 or 1
    """
    now = int(time.time())
    t = time.localtime(now)
    time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                        '%Y-%m-%d %H:%M:%S'))
    return int(time1/(24*60*60)) % 2


def do_tick():
    if flag_doublu_day():
        level_rank_name = 'LevelRank2'
        power_rank_name = 'PowerRank2'
        star_rank_name = 'StarRank2'
    else:
        level_rank_name = 'LevelRank1'
        power_rank_name = 'PowerRank1'
        star_rank_name = 'StarRank1'

    users = tb_character_info.smem('all')

    instance = Ranking.instance(level_rank_name)
    add_level_rank_info(instance, users)

    instance = Ranking.instance(power_rank_name)
    add_power_rank_info(instance, users)

    instance = Ranking.instance(star_rank_name)
    add_star_rank_info(instance, users)


def tick1():
    do_tick
    need_time1 = 24*60*60
    reactor.callLater(need_time1, tick1)

do_tick()

now = int(time.time())
t = time.localtime(now)
time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t), '%Y-%m-%d %H:%M:%S'))
need_time = 24*60*60 - (now - time1) + 2

reactor.callLater(need_time, tick1)
