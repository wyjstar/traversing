# coding: utf-8

import time
import datetime


def timestamp():
    """
    Get server time stamp.
    """
    return int(time.time())


def mstimestamp():
    """
    Get time stamp accurate to millisecond.
    """
    return int(time.time() * 1000)


def strdate():
    """
    Get current date.

    @return: YYYYmmdd
    @rtype: 8s
    """
    return time.strftime("%Y%m%d", time.localtime(time.time()))


def strtime():
    """
    Get current time.

    @return: HHMMSS
    @rtype: 6s
    """
    return time.strftime("%H%M%S", time.localtime(time.time()))


def strdatetime():
    """
    Get current date and time.

    @return: YYYY-mm-dd HH:MM:SS
    @rtype: 6s
    """
    return time.strftime("%Y-%m-%d %H:%M:%S", time.localtime(time.time()))

def utctimestamp():
    """Get UTC timestamp.

    @rtype: 10d
    """
    return int(time.mktime(time.gmtime()))

def timestambytz(tz):
    """
    Get user timestamp with user's timezone.

    @rtype: 10d
    """
    return int(time.mktime(time.gmtime()) + tz)

def strdatetimebytz(tz):
    """
    Get user date and time with user's timezone.

    @rtype: 10d
    """
    try:
        uts = timestambytz(tz)
        return (datetime.datetime.fromtimestamp(uts)).strftime("%Y-%m-%d %H:%M:%S")
    except:
        raise

def strdatebytz(tz):
    """
    Get user date with user's timezone.

    @rtype: 10d
    """
    try:
        uts = timestambytz(tz)
        return (datetime.datetime.fromtimestamp(uts)).strftime("%Y%m%d")
    except:
        raise

def strdatefromts(stamp):
    """
    Get date value with timestamp.

    @rtype: YYmmdd
    """
    return (datetime.datetime.fromtimestamp(stamp)).strftime("%Y%m%d")

def strdatetimefromts(stamp):
    """
    Get datetime with timestamp.

    @rtype: %Y-%m-%d %H:%M
    """
    return (datetime.datetime.fromtimestamp(stamp)).strftime("%Y-%m-%d %H:%M")

def strdatetimefromts_ss(stamp):
    """
    Get datetime with timestamp.

    @rtype: %Y-%m-%d %H:%M
    """
    return (datetime.datetime.fromtimestamp(stamp)).strftime("%Y-%m-%d %H:%M:%S")

def tsfromstrdate(s, with_sec=False):
    """
    Convert datetime string to timestamp.

    @rtype: 10d
    """
    pattern = "%Y-%m-%d %H:%M:%S" if with_sec else "%Y-%m-%d %H:%M"
    return int(time.mktime(datetime.datetime.strptime(s, pattern).timetuple()))

def foract(s):
    """
    Convert datetime string to timestamp.

    @rtype: 10d
    """
    return int(time.mktime(datetime.datetime.strptime(s, "%Y-%m-%d %H:%M:%S").timetuple()))

def today_ts():
    """
    Get timestamp of today.

    @rtype: 10d
    """
    s = datetime.date.today()
    return int(time.mktime(s.timetuple()))

def tomorrow_ts():
    return today_ts() + 86400

def week_num():
    w = datetime.date.today().isocalendar()[1]
    return w

def now_hour():
    return datetime.datetime.now().hour

def now_minutes():
    now = datetime.datetime.now()
    return now.hour * 60 + now.minute

def minutesfromstr(s):
    """
    Convert %H:%M to minutes.
    """
    arr = map(int, s.split(':'))
    hour, minute = arr
    return hour * 60 + minute

def dateToTime(d):
    return tsfromstrdate(d, with_sec=True)

def timestamp_to_date(timestamp):
    return datetime.datetime.fromtimestamp(timestamp)

if __name__ == '__main__':
    xx = timestamp_to_date(time.time())
    print xx.year, xx.month, xx.day
