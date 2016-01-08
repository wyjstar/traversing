# -*- coding:utf-8 -*-
"""
@author: cui
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
import random
from shared.utils.random_pick import random_multi_pick_without_repeat
import time
from time import localtime
from gfirefly.server.globalobject import GlobalObject


server_open_time = int(time.mktime(
    time.strptime(GlobalObject().allconfig['open_time'], '%Y-%m-%d %H:%M:%S')))


def do_get_act_open_info(act_id, register_time=0):
    day_xs = 60 * 60 * 24
    hour_xs = 60 * 60
    is_open = 0
    time_start = 0
    time_end = 0
    now = int(time.time())
    register_time0 = 0

    if register_time:
        register_time0 = get_time0(register_time)
    if server_open_time:
        server_open_time0 = get_time0(server_open_time)

    act_conf = game_configs.activity_config.get(act_id)
    if not act_conf:
        return {'is_open': 0, 'time_start': 0, 'time_end': 0}
    duration = act_conf.duration

    if not act_conf.timeEnd:
        return {'is_open': 0, 'time_start': 0, 'time_end': 0}

    if duration == 1 or duration == 2:
        time_start = act_conf.timeStart
        time_end = act_conf.timeEnd
    elif duration == 4 or duration == 3:
        time_start = server_open_time0 + (act_conf.timeStart-1) * day_xs
        time_end = server_open_time0 + (act_conf.timeEnd) * day_xs
    elif duration == 5:
        time_start = server_open_time0 + (act_conf.timeStart-1) * hour_xs
        time_end = server_open_time0 + (act_conf.timeEnd) * hour_xs

    elif duration == 7 or duration == 6:
        time_start = register_time0 + (act_conf.timeStart-1) * day_xs
        time_end = register_time0 + (act_conf.timeEnd) * day_xs
    elif duration == 8:
        time_start = register_time0 + (act_conf.timeStart-1) * hour_xs
        time_end = register_time0 + (act_conf.timeEnd) * hour_xs

    if time_start <= now <= time_end:
        is_open = 1
    return {'is_open': is_open, 'time_start': time_start, 'time_end': time_end}


def get_time0(t):
    # 时间戳当天的零点时间戳
    t1 = time.localtime(t)
    return int(time.mktime(time.strptime(
               time.strftime('%Y-%m-%d 00:00:00', t1),
               '%Y-%m-%d %H:%M:%S')))
