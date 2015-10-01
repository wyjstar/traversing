# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午9:05.
"""
import time
from gtwisted.core import reactor


class TEManager(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._events = {}  # {time:[函数]}
        self._day_events = {}  # {time:[函数]}

    def add_event(self, time, type, event):
        """
        time 当日秒数 时间戳
        type 1 时间戳 2 当日秒数
        event 函数
        """
        if type == 1:
            if self._events.get(time):
                self._events[time].append(event)
            else:
                self._events[time] = [event]
        elif type == 2:
            if self._day_events.get(time):
                self._day_events[time].append(event)
            else:
                self._day_events[time] = [event]

    @property
    def events(self):
        return self._events

    @events.setter
    def events(self, v):
        self._events = v

    def deal_event(the_time):
        now = int(time.time())
        next_time = 0
        for x, _ in self._events.items():
            if x <= now or x > now+60:
                continue
            if not next_time:
                next_time = x
                continue
            if x < next_time:
                next_time = x
        for x, _ in self._day_events.items():
            if x <= now or x > now+60:
                continue
            if not next_time:
                next_time = x
                continue
            if x < next_time:
                next_time = x
        reactor.callLater(x, deal_event, time)
