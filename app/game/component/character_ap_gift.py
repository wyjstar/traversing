# -*- coding:utf-8 -*-
"""
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterApGiftComponent(Component):
    """CharacterApGiftComponent"""

    def __init__(self, owner):
        super(CharacterApGiftComponent, self).__init__(owner)
        self._received_gift_ids = []
        self._received_time = 1

    def init_data(self, character_info):
        data = character_info.get('ap_gift')
        self._received_gift_ids = data['received_gift_ids']
        self._received_time = data['received_time']

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_gift_ids=self._received_gift_ids,
                    received_time=self._received_time)
        character_obj.hset('ap_gift', data)

    def new_data(self):
        data = dict(received_gift_ids=[],
                    received_time=self._received_time)
        return {'ap_gift': data}

    @property
    def received_gift_ids(self):
        return self._received_gift_ids

    @received_gift_ids.setter
    def received_gift_ids(self, value):
        self._received_gift_ids = value

    @property
    def received_time(self):
        return self._received_time

    @received_time.setter
    def received_time(self, value):
        self._received_time = value
