# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity


class CharacterLevelGift(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterLevelGift, self).__init__(owner)
        self._received_gift_ids = []

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)

        if activity:
            data = activity.get('level_gift')
            if data and data != 'None':
                self._received_gift_ids = data['received_gift_ids']
            else:
                self.received_gift_ids = []
                self.save_data()
        else:
            data = dict(received_gift_ids=self._received_gift_ids)
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'level_gift': data})

    def save_data(self):
        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = dict(received_gift_ids=self._received_gift_ids)
        activity.update('level_gift', data)

    @property
    def received_gift_ids(self):
        return self._received_gift_ids

    @received_gift_ids.setter
    def received_gift_ids(self, value):
        self._received_gift_ids = value
