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
        # 时间过去必须要做的事件 比如限时武将活动的结算 所有活动的结算

    def add_event(self, time, type, event):
        """
        time 事件处理时间 当日秒数 时间戳
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

    def deal_event(self, the_time=0):
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

        t = time.localtime(now)
        time0 = int(time.mktime(time.strptime(
                            time.strftime('%Y-%m-%d 00:00:00', t),
                            '%Y-%m-%d %H:%M:%S')))
        for x, _ in self._day_events.items():
            x_time = time0 + x

            if x_time <= now or x_time > now+60:
                continue
            if not next_time:
                next_time = x_time
                continue
            if x_time < next_time:
                next_time = x_time

        if next_time:
            reactor.callLater(next_time-now, self.deal_event, the_time=next_time)
        else:
            reactor.callLater(60, self.deal_event, the_time=next_time)

        if not the_time:
            return
        day_time = the_time - time0
        if not day_time:
            day_time = 60 * 60 * 24
        events = self._events.get(the_time, [])
        for event in events:
            event()
        events = self._day_events.get(day_time, [])
        for event in events:
            event()

te_manager = TEManager()
