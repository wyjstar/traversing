# -*- coding:utf-8 -*-
"""
created by server on 14-8-12下午2:17.
"""
from app.proto_file.feast_pb2 import EatFeastResponse, GetEatTimeResponse
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
import time
from shared.tlog import tlog_action


@remoteserviceHandle('gate')
def feast_820(pro_data, player):
    """美味酒席
    """
    response = EatFeastResponse()
    res = eat_feast(player)
    response.res = res
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_eat_time_821(pro_data, player):
    """获取上次吃的时间
    """
    response = GetEatTimeResponse()
    last_eat_time = player.feast.last_eat_time
    response.res.result = True
    response.eat_time = last_eat_time
    return response.SerializeToString()


def eat_feast(player):
    """ 吃 """
    """
    # (tm_year=2014, tm_mon=9, tm_mday=1, tm_hour=18, tm_min=38, tm_sec=1, tm_wday=0, tm_yday=244, tm_isdst=0)
    last_eat_time = time.localtime(player.feast.last_eat_time).tm_hour*60*60 + \
        time.localtime(player.feast.last_eat_time).tm_min*60 + time.localtime(player.feast.last_eat_time).tm_sec
    eat_times = game_configs.base_config.get(u'time_vigor_activity')
    now = time.localtime().tm_hour*60*60 + time.localtime().tm_min*60 + time.localtime().tm_sec
    for eat_time in eat_times:
        t1 = eat_time[0].split(':')
        time1 = int(t1[0])*60*60 + int(t1[1])*60
        t2 = eat_time[1].split(':')
        time2 = int(t2[0])*60*60 + int(t2[1])*60
        if time2 >= now >= time1:
            if time2 >= last_eat_time >= time1:
                # 已经吃过
                return 1
            # 吃
            player.stamina.stamina += game_configs.base_config.get(u'num_vigor_activity')
            player.stamina.save_data()
            player.feast.last_eat_time = int(time.time())
            player.feast.save_data()
            return 2
    # 没到时间
    return 3
    """

    last_eat_time = player.feast.last_eat_time
    now = int(time.time())
    eat_times = game_configs.base_config.get(u'time_vigor_activity')
    t = time.localtime(now)
    for eat_time in eat_times:
        time1 = time.mktime(time.strptime(time.strftime('%Y-%m-%d '+eat_time[0]+':00', t), '%Y-%m-%d %H:%M:%S'))
        time2 = time.mktime(time.strptime(time.strftime('%Y-%m-%d '+eat_time[1]+':00', t), '%Y-%m-%d %H:%M:%S'))
        if time2 >= now >= time1:
            if time2 >= last_eat_time >= time1:
                # 已经吃过
                return 1
            # 吃
            player.stamina.stamina += game_configs.base_config.get(u'num_vigor_activity')
            player.stamina.save_data()
            player.feast.last_eat_time = int(time.time())
            player.feast.save_data()
            tlog_action.log('Feast', player, player.stamina.stamina)
            return 2
    # 没到时间
    return 3
