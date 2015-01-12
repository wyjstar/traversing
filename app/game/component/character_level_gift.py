# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterLevelGift(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterLevelGift, self).__init__(owner)
        self._received_gift_ids = []
        self._level_gift = [0] * 250

    def init_data(self, character_info):
        data = character_info.get('level_gift')
        self._received_gift_ids = data['received_gift_ids']
        self._level_gift = data['level_gift']

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_gift_ids=self._received_gift_ids,
                    level_gift=self._level_gift)
        activity.hset('level_gift', data)

    def new_data(self):
        data = dict(received_gift_ids=[],
                    level_gift=self._level_gift)
        return {'level_gift': data}

    @property
    def received_gift_ids(self):
        return self._received_gift_ids

    @received_gift_ids.setter
    def received_gift_ids(self, value):
        self._received_gift_ids = value

    @property
    def level_gift(self):
        return self._level_gift

    @level_gift.setter
    def level_gift(self, value):
        self._level_gift = value
