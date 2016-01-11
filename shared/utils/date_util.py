#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
# from xtime import timestamp_to_date
import datetime


def get_timestamp(year, month, day, hour=0, minute=0, sec=0):
    """
    input: 2014, 1, 1
    output: 14223411.0
    """
    d = datetime.datetime(year, month, day, hour, minute, sec)
    return time.mktime(d.timetuple())


def get_current_day_timestamp(hour=0, minute=0, sec=0):
    """
    input: 0, 0, 0
    output: 1422311.0
    """
    now = datetime.datetime.now()
    return get_timestamp(now.year, now.month, now.day, hour, minute, sec)


def get_current_timestamp():
    return time.time()


def string_to_timestamp(time_str, scheme="%Y/%m/%d %H:%M:%S"):
    """
    input: 2014-09-01 23:59
    output: num
    """
    d = datetime.datetime.strptime(time_str, scheme)
    return time.mktime(d.timetuple())


def string_to_timestamp_hms(time_str):
    """
    input: 23:59:00
    output: num
    """
    times = time_str.split(':')
    return get_current_day_timestamp(hour=int(times[0]), minute=int(times[1]))


def str_time_period_to_timestamp(str_time_period):
    """
    input: 12:30-12:40
    """
    times = str_time_period.split('-')
    time1 = times[0]
    time2 = times[1]

    time1s = time1.split(':')
    time2s = time2.split(':')

    return (get_current_day_timestamp(hour=int(time1s[0]),
                                      minute=int(time1s[1])),
            get_current_day_timestamp(hour=int(time2s[0]),
                                      minute=int(time2s[1])))


def str_time_to_timestamp(str_time):
    _time = str_time.split(':')
    return get_current_day_timestamp(hour=int(_time[0]), minute=int(_time[1]))


def is_next_day(current_time_stamp, last_time_stamp):
    """docstring for is_nextfname"""
    return days_to_current(last_time_stamp) > 0


def days_to_current(timestamp):
    now = time.localtime(time.time())
    some_date = time.localtime(timestamp)
    yday = now.tm_yday
    if now.tm_year > some_date.tm_year:
        diff = 365
        if not some_date.tm_year % 4:
            diff = 366
        yday = yday + diff

    return yday - some_date.tm_yday


def is_past_time(next_time, last_time):
    """
    current_time是否超过下一个时间next_time
    last_time 上次操作时间
    next_time 下次应该操作时间 (时:分:秒)：比如下次自动刷新商城
    return 下次的应该操作时间
    """
    _next_time = next_time.split(':')
    some_date = time.localtime(last_time)

    # get_timestamp(int(_next_time[0], int(_next_time[1]), int(_next_time[2]))
    hour = int(_next_time[0])
    minute = int(_next_time[1])
    sec = int(_next_time[2])

    d = datetime.datetime(some_date.tm_year, some_date.tm_mon,
                          some_date.tm_mday, hour, minute, sec)
    if d < datetime.datetime.fromtimestamp(last_time):
        d = d + datetime.timedelta(days=1)
    return time.mktime(d.timetuple())


def is_in_period(periods):
    """
    格式：[("12:00","14:00"),("18:00","20:00")]
    """
    now = get_current_timestamp()
    for item in periods:
        t0 = item[0].split(':')
        t1 = item[1].split(':')
        start = get_current_day_timestamp(hour=int(t0[0]), minute=int(t0[1]))
        end = get_current_day_timestamp(hour=int(t1[0]), minute=int(t1[1]))
        if start < now and now < end:
            return True
    return False


def is_expired(last_time, expired_time):
    return last_time + expired_time < get_current_timestamp()


if __name__ == '__main__':
    print get_timestamp(2014, 11, 22)
    print get_current_day_timestamp(0, 0, 0)
    # print string_to_timestamp("2014-09-01 23:59:00")
    # print str_time_period_to_timestamp("20:00-23:59")
    print days_to_current(1429284715)
