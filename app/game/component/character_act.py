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

    def init_data(self, character_info):
        data = character_info.get('act_info')
        if not data:
            self.new_data()
            return
        self._received_ids = data['received_ids']
        self._received_time = data['received_time']

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_ids=self._received_ids,
                    received_time=self._received_time)
        character_obj.hset('act_info', data)

    def new_data(self):
        data = dict(received_ids={},
                    received_time=self._received_time)
        return {'act_info': data}

    def is_activiy_open(self, act_id):
        return self.get_act_open_info(act_id).get('is_open')

    def get_act_open_info(self, act_id):
        act_conf = game_configs.activity_config.get(act_id)
        register_time = self.owner.base_info.register_time
        return do_get_act_open_info(
            act_id,
            already_open_act_ids=self.already_open_act_ids,
            register_time=register_time,
            server_open_time=0)

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
