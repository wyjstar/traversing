# -*- coding:utf-8 -*-
"""
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
import time


class CharacterActComponent(Component):
    """CharacterActComponent"""

    def __init__(self, owner):
        super(CharacterActComponent, self).__init__(owner)
        self._received_ids = {}
        self._received_time = 1
        self._act23_info = [0, 1, 0]  # [次数，时间, 领取状态]

    def init_data(self, character_info):
        data = character_info.get('act_info')
        if not data:
            self.new_data()
            return
        self._received_ids = data['received_ids']
        self._received_time = data['received_time']
        self._act23_info = data.get('act23_info', 0)

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_ids=self._received_ids,
                    received_time=self._received_time,
                    act23_info=self._act23_info)
        character_obj.hset('act_info', data)

    def new_data(self):
        data = dict(received_ids={},
                    received_time=self._received_time,
                    act23_info=self._act23_info)
        return {'act_info': data}

    @property
    def received_ids(self):
        return self._received_ids

    @received_ids.setter
    def received_ids(self, value):
        self._received_ids = value

    @property
    def received_time(self):
        return self._received_time

    @received_time.setter
    def received_time(self, value):
        self._received_time = value

    @property
    def act23_info(self):
        return self._act23_info

    @act23_info.setter
    def act23_info(self, value):
        self._act23_info = value

    def add_act23_times(self):
        if time.localtime(self._act23_info[1]).tm_yday == \
                time.localtime().tm_yday:
            self._act23_info[0] += 1
        else:
            self._act23_info = [1, int(time.time()), 0]

    @property
    def act23_times(self):
        if time.localtime(self._act23_info[1]).tm_yday == \
                time.localtime().tm_yday:
            return self._act23_info[0]
        else:
            return 0

    @property
    def act23_state(self):
        if time.localtime(self._act23_info[1]).tm_yday == \
                time.localtime().tm_yday:
            return self._act23_info[2]
        else:
            return 0
