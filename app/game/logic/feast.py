# -*- coding:utf-8 -*-
"""
created by server on 14-8-15下午5:30.
"""
from app.game.logic.common.check import have_player
from shared.db_opear.configs_data.game_configs import base_config
import time


@have_player
def eat_feast(dynamicid, **kwargs):
    """
    吃
    """
    # (tm_year=2014, tm_mon=9, tm_mday=1, tm_hour=18, tm_min=38, tm_sec=1, tm_wday=0, tm_yday=244, tm_isdst=0)
    player = kwargs.get('player')
    last_eat_time = time.localtime(player.feast.last_eat_time).tm_hour*60*60 + \
        time.localtime(player.feast.last_eat_time).tm_min*60
    eat_times = base_config.get(u'manual_give_time')
    now = time.localtime().tm_hour*60*60 + time.localtime().tm_min*60
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
            player.stamina += base_config.get(u'manual_give_value')
            player.feast.last_eat_time = int(time.time())
            player.save_data()
            return 2
    # 没到时间
    return 3


@have_player
def get_time(dynamicid, **kwargs):
    """
    获取上次吃大餐时间
    """
    player = kwargs.get('player')
    return player.feast.last_eat_time


