# -*- coding:utf-8 -*-
"""
created by server on 14-11-9下午5:11.
"""
import action

from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_mode import RedisObject
import time
from gtwisted.core import reactor
from app.world.core.rank_helper import add_level_rank_info, \
    add_power_rank_info, add_star_rank_info


tb_character_info = RedisObject('tb_character_info')

# 初始化工会排行
Ranking.init('LevelRank1', 99999)
Ranking.init('LevelRank2', 99999)
Ranking.init('PowerRank1', 99999)
Ranking.init('PowerRank2', 99999)
Ranking.init('StarRank1', 99999)
Ranking.init('StarRank2', 99999)


def flag_doublu_day():
    """
    return 0 or 1
    """
    now = int(time.time())
    t = time.localtime(now)
    time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                        '%Y-%m-%d %H:%M:%S'))
    return int(time1/(24*60*60)) % 2


def tick():
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
    add_level_rank_info(instance, users, tb_character_info)

    instance = Ranking.instance(power_rank_name)
    add_power_rank_info(instance, users, tb_character_info)

    instance = Ranking.instance(star_rank_name)
    add_star_rank_info(instance, users, tb_character_info)


def do_tick():
    tick()
    need_time1 = 24*60*60
    reactor.callLater(need_time1, do_tick)

now = int(time.time())
t = time.localtime(now)
time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d 00:00:00', t),
                    '%Y-%m-%d %H:%M:%S'))
need_time = 24*60*60 - (now - time1) + 2

tick()
reactor.callLater(need_time, do_tick)
