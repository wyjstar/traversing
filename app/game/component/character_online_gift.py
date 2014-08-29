# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity


class CharacterOnlineGift(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterOnlineGift, self).__init__(owner)
        activity = tb_character_activity.getObjData(self.owner.base_info.id)
        self._received_gift_ids = []

        if activity:
            self._received_gift_ids = activity.get('online_gift')
        else:
            tb_character_activity.new('online_gift', [])

    def init_data(self):
        pass

    def save_data(self):
        pass
