# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午9:05.
"""
import time


class TEManager(object):
    """公会
    """
    def __init__(self):
        """
        """
        self._events = {}  # {time:[函数]}
        self._day_events = {}  # {time:[函数]}
        self._last_deal = 1  # 上次更新时间

    def add_event(self, time, type, event):
        pass

    @property
    def events(self):
        return self._events

    @events.setter
    def events(self, v):
        self._events = v
