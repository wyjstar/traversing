#!/usr/bin/env python
# -*- coding: utf-8 -*-

import time
from xtime import timestamp_to_date
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

def string_to_timestamp(time_str):
    """
    input: 2014-09-01 23:59
    output: num
    """
    d = datetime.datetime.strptime(time_str, "%Y/%m/%d %H:%M:%S")
    return time.mktime(d.timetuple())

def str_time_period_to_timestamp(str_time_period):
    """
    input: 12:30-12:40
    """
    times = str_time_period.split('-')
    time1 = times[0]
    time2 = times[1]

    time1s = time1.split(':')
    time2s = time2.split(':')

    return (get_current_day_timestamp(hour=int(time1s[0]), minute=int(time1s[1])),
    get_current_day_timestamp(hour=int(time2s[0]), minute=int(time2s[1])))

def str_time_to_timestamp(str_time):
    _time = str_time.split(':')
    return get_current_day_timestamp(hour=int(_time[0]), minute=int(_time[1]))

def is_next_day(current_time_stamp, last_time_stamp):
    """docstring for is_nextfname"""
    current_date = timestamp_to_date(current_time_stamp)
    last_date = timestamp_to_date(last_time_stamp)
    if current_date.year >= current_date.year \
        and current_date.month >= last_date.month \
        and current_date.day > last_date.day:
            return True
    return False

def days_to_current(timestamp):
    current_date = datetime.datetime.now()
    some_date = timestamp_to_date(timestamp)
    return (current_date-some_date).days


if __name__ == '__main__':
    print get_timestamp(2014,11,22)
    print get_current_day_timestamp(0, 0, 0)
    print string_to_timestamp("2014-09-01 23:59:00")
    print str_time_period_to_timestamp("20:00-23:59")

