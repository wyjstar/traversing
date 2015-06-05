# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import time
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component


class CharacterOnlineGift(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterOnlineGift, self).__init__(owner)
        self._login_on_time = time.time()
        self._online_time = 0
        self._refresh_time = time.time()
        self._received_gift_ids = []

    def init_data(self, character_info):
        data = character_info.get('online_gift')
        self._online_time = data['online_time']
        # self._online_time = 0
        self._refresh_time = data.get('refresh_time', time.time())
        self._received_gift_ids = data['received_gift_ids']
        self.check_time()

        logger.debug(self.__dict__)

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(online_time=self._online_time,
                    refresh_time=self._refresh_time,
                    received_gift_ids=self._received_gift_ids)
        activity.hset('online_gift', data)

    def new_data(self):
        data = dict(online_time=self._online_time,
                    refresh_time=self._refresh_time,
                    received_gift_ids=self._received_gift_ids)
        return {'online_gift': data}

    def offline_player(self):
        accumulate_time = time.time() - self._login_on_time
        self._online_time += accumulate_time
        self.save_data()

    def check_time(self):
        tm = time.localtime(self._refresh_time)
        local_tm = time.localtime()
        if local_tm.tm_year != tm.tm_year or local_tm.tm_yday != tm.tm_yday:
            self._online_time = 0
            self._login_on_time = time.time()
            self._refresh_time = time.time()
            self._received_gift_ids = []
            self.save_data()

    def reset(self):
        self._refresh_time = time.time()
        self._login_on_time = time.time()
        self.online_time = 0

    @property
    def online_time(self):
        self.check_time()
        elapse = time.time() - self._login_on_time
        return self._online_time + elapse

    @online_time.setter
    def online_time(self, value):
        self._online_time = value

    @property
    def received_gift_ids(self):
        return self._received_gift_ids

    @received_gift_ids.setter
    def received_gift_ids(self, value):
        self._received_gift_ids = value
