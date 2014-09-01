# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import datetime
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity


class CharacterOnlineGift(Component):
    """CharacterOnlineGift"""

    def __init__(self, owner):
        super(CharacterOnlineGift, self).__init__(owner)
        self._login_on_time = datetime.datetime.now()
        self._online_time = 0
        self._received_gift_ids = []

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)

        if activity:
            data = activity.get('online_gift')
            if data:
                self._online_time = data['online_time']
                self._received_gift_ids = data['received_gift_ids']
        else:
            data = {'online_time': self._online_time,
                    'received_gift_ids': self._received_gift_ids}
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'online_gift': data})

    def save_data(self):
        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = {'online_time': self._online_time,
                'received_gift_ids': self._received_gift_ids}
        print 'offline datetime', data
        activity.update('online_gift', data)

    def offline_player(self):
        accumulate_time = datetime.datetime.now() - self._login_on_time
        self._online_time += accumulate_time.seconds
        self.save_data()

    @property
    def online_time(self):
        return self._online_time

    @online_time.setter
    def online_time(self, value):
        self._online_time = value

    @property
    def received_gift_ids(self):
        return self._received_gift_ids

    @received_gift_ids.setter
    def received_gift_ids(self, value):
        self._received_gift_ids = value
