# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterBuyCoinActivity(Component):
    """CharacterBuyCoinActivity"""

    def __init__(self, owner):
        super(CharacterBuyCoinActivity, self).__init__(owner)
        self._buy_times = 0  # 已购买次数
        self._last_time = 0  # 上次购买时间
        self._extra_can_buy_times = 0 # 招财符提高的可购买次数

    def init_data(self, character_info):
        data = character_info.get('buy_coin', {})
        self._buy_times = data.get('buy_times', 0)
        self._last_time = data.get('last_time', 0)
        #self._extra_can_buy_times = data.get('extra_can_buy_times', 0)

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(buy_times=self._buy_times,
                    #extra_can_buy_times=self._extra_can_buy_times,
                    last_time=self._last_time
                    )
        activity.hset('buy_coin', data)

    def new_data(self):
        data = dict(buy_times=self._buy_times,
                    extra_can_buy_times=self._extra_can_buy_times,
                    last_time=self._last_time
                    )
        return {'buy_coin': data}

    @property
    def buy_times(self):
        return self._buy_times

    @buy_times.setter
    def buy_times(self, value):
        self._buy_times = value

    #@property
    #def extra_can_buy_times(self):
        #return self._extra_can_buy_times

    #@extra_can_buy_times.setter
    #def extra_can_buy_times(self, value):
        #self._extra_can_buy_times = value

    @property
    def last_time(self):
        return self._last_time

    @last_time.setter
    def last_time(self, value):
        self._last_time = value
