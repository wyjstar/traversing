# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity
import time


class CharacterLoginGiftComponent(Component):
    """登录活动"""

    def __init__(self, owner):
        super(CharacterLoginGiftComponent, self).__init__(owner)
        self._received = []  # 已经领过的
        self._continuous_day = 0  # 连续登录天数
        self._cumulative_day = 0  # 累积登录天数
        self._last_login = int(time.time())  # 日期

    def init_feast(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)
        if activity:
            data = activity.get('login_gift')
            if data:
                if data.get('last_login'):
                    if time.localtime(data.get('last_login')).tm_mday == time.localtime().tm_mday:  # 上次更新是今天
                        if data.get('received'):
                            self._received = data.get('received')
                        if data.get('continuous_day'):
                            self._continuous_day = data.get('continuous_day')
                        if data.get('cumulative_day'):
                            self._cumulative_day = data.get('cumulative_day')
                    else:
                        if data.get('received'):
                            self._received = data.get('received')
                        if data.get('continuous_day'):
                            self._continuous_day = data.get('continuous_day') + 1
                        if data.get('cumulative_day'):
                            self._cumulative_day = data.get('cumulative_day') + 1
        else:
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'login_gift': {}})
        self.save_data()

    def save_data(self):
        sign_in_data = tb_character_activity.getObj(self.owner.base_info.id)
        sign_in_data.update('login_gift', {
            'received': self._received,
            'continuous_day': self._continuous_day,
            'cumulative_day': self._cumulative_day
        })

    @property
    def received(self):
        return self._received

    @received.setter
    def received(self, value):
        self._received = value

    @property
    def continuous_day(self):
        return self._continuous_day

    @continuous_day.setter
    def continuous_day(self, value):
        self._continuous_day = value

    @property
    def cumulative_day(self):
        return self._cumulative_day

    @cumulative_day.setter
    def cumulative_day(self, value):
        self._cumulative_day = value

