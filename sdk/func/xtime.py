# coding: utf-8
# Created on 2013-8-28
# Author: jiang

""" time相关扩展方法
"""

import datetime
import time


def date(days=0, rtype='int', connector='', ts=0):
    """
    获取指定日期
    @param days: 推进天数
    @param rtype: 'int' or string
    @param connector: 连接符合，'', ’-‘
    @param ts: 指定时间戳，不指定则为现在
    @return: YYYYmmdd, 'YYYYmmdd', 'YYYY-mm-dd'

    Example:
        date(days=1, rtype='str', connector='#')
        >> 2014#12#30
    """
    if rtype == 'int':
        connector = ''
    pattern = '%Y' + connector + '%m' + connector + '%d'
    if not ts:
        ts = time.time() + 86400 * days
    str_val = time.strftime(pattern, time.localtime(ts))
    if rtype == 'int':
        return int(str_val)
    return str_val


def datetots(date):
    """
    日期转为时间戳
    @param date: '20140212' or '2014-02-12'

    Example:
        datetots('20140212')
        >> 1392134400
    """
    date = ''.join(str(date).split('-'))
    timetuple = datetime.datetime.strptime(date, "%Y%m%d").timetuple()
    return int(time.mktime(timetuple))


def datetimetots(datetimestr, with_sec=False):
    """
    时间转为时间戳
    @param datetimestr: '2014-02-12 12:00'

    Example:
        datetimetots('2014-02-12 12:00')
        >> 1392134400
    """
    pattern = "%Y-%m-%d %H:%M:%S" if with_sec else "%Y-%m-%d %H:%M"
    return int(time.mktime(datetime.datetime.strptime(datetimestr, pattern).timetuple()))


def dateinterdays(from_date, to_date):
    """
    指定时间戳间隔的现实天数
    @param from_date, to_date: '20140212' or '2014-02-12'

    Example:
        dateinterdays('2014-12-31', '2015-01-01')
        >> 1
    """
    ts2 = datetots(to_date)
    ts1 = datetots(from_date)
    days = int((ts2 - ts1) / 86400)
    return days


def nextday(the_date):
    """
    获取the_date的下一天
    @param the_date: '20140212' or '2014-02-12'

    Example:
        nextday('20141231')
        >> 20150101
    """
    next_date_ts = datetots(the_date) + 86400
    return date(ts=next_date_ts, rtype='int')


def timestamp(precision=1, utc=False):
    """
    获取时间戳，默认10位秒级
    @param precision: 时间精度

    Example:
        timestamp(precision=1000)
        >> 1419838408497
    """
    if utc:
        return int(time.mktime(time.gmtime()) * precision)
    else:
        return int(time.time() * precision)


def mstimestamp(utc=False):
    """
    获取13位毫秒级时间戳

    Example:
        mstimestamp()
        >> 1419838647685
        mstimestamp(utc=True)
        >> 1419809847000
    """
    return timestamp(precision=1000, utc=utc)


def today():
    """
    获取今天日期

    Example:
        today()
        >> 2014-12-29
    """
    return datetime.date.today()


def todayts():
    """
    获取今天凌晨的时间戳
    """
    return int(time.mktime(today().timetuple()))


def afterdayts(days=1):
    """
    days天后的凌晨时间戳
    """
    return todayts() + 86400 * days


def weeknum():
    """
    本周是今年的第几周
    """
    return datetime.date.today().isocalendar()[1]

    
def nowhour():
    """
    获取当前小时数，24时制
    """
    return datetime.datetime.now().hour


def nowminutes():
    """
    获取当前分钟数
    """
    now = datetime.datetime.now()
    return now.hour * 60 + now.minute

def nowdatehours():
    """
    获得当前时间，精确到小时
    Example:
        nowdatehours()
        >> 2015010917
    """
    time_struct = time.localtime()
    time_int = time_struct.tm_year
    time_int = time_int*100 + time_struct.tm_mon
    time_int = time_int*100 + time_struct.tm_mday
    time_int = time_int*100 + time_struct.tm_hour
    time_str = str(time_int)
    return time_str

def strdatetime():
    """
    Get current date and time.

    @return: YYYY-mm-dd HH:MM:SS
    @rtype: 6s
    """
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))
