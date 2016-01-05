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
import shared.utils import xtime


def do_get_act_open_info(act_id, already_open_act_ids=[],
                         register_time=0, server_open_time=0):
    day_xs = 60 * 60 * 24
    hour_xs = 60 * 60
    is_open = 0
    time_start = 0
    time_end = 0
    now = int(time.time())
    register_time0 = 0
    server_open_time0 = 0

    if register_time:
        register_time0 = xtime.get_time0(register_time)
    if server_open_time:
        server_open_time0 = xtime.get_time0(server_open_time)

    act_conf = game_configs.activity_config.get(act_id)
    duration = act_conf.duration

    if not act_conf.timeStart:
        return {'is_open': 0, 'time_start': 0, 'time_end': 0}
    if act_id in already_open_act_ids:  # 类型是 3 6
        return {'is_open': 1, 'time_start': 0, 'time_end': 0}

    if duration == 1 or duration == 2:
        time_start = act_conf.timeStart
        time_end = act_conf.timeEnd
    elif duration == 3:
        time_start = server_open_time0 + (act_conf.timeStart-1) * day_xs
        time_end = server_open_time0 + (act_conf.timeEnd-1) * day_xs
    elif duration == 4:
        time_start = server_open_time0 + (act_conf.timeStart-1) * day_xs
        time_end = server_open_time0 + (act_conf.timeEnd-1) * day_xs
    elif duration == 5:
        time_start = server_open_time0 + (act_conf.timeStart-1) * hour_xs
        time_end = server_open_time0 + (act_conf.timeEnd-1) * hour_xs

    elif duration == 6:
        time_start = register_time0 + (act_conf.timeStart-1) * day_xs
        time_end = register_time0 + (act_conf.timeEnd-1) * day_xs
    elif duration == 7:
        time_start = register_time0 + (act_conf.timeStart-1) * day_xs
        time_end = register_time0 + (act_conf.timeEnd-1) * day_xs
    elif duration == 8:
        time_start = register_time0 + (act_conf.timeStart-1) * hour_xs
        time_end = register_time0 + (act_conf.timeEnd-1) * hour_xs

    if time_start <= now <= time_end:
        is_open = 1
    return {'is_open': is_open, 'time_start': time_start, 'time_end': time_end}


