# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import datetime
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity
from shared.db_opear.configs_data.game_configs import activity_config


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

    # def save_data(self):
    #     pass

    def offline_player(self):
        accumulate_time = datetime.datetime.now() - self._login_on_time
        self._online_time += accumulate_time.seconds

        activity = tb_character_activity.getObj(self.owner.base_info.id)
        data = {'online_time': self._online_time,
                'received_gift_ids': self._received_gift_ids}
        print 'offline datetime', data
        activity.update('online_gift', data)

    def get_online_gift(self, gift_id):
        values = activity_config.values()
        activity_online_gift = filter(lambda _: _['type'] == 4, values)
        online_minutes = self._online_time  #  / 60

        if gift_id in self._received_gift_ids:
            return False

        activity = tb_character_activity.getObj(self.owner.base_info.id)
        if not activity:
            return False

        for a in activity_online_gift:
            if gift_id == a['id']:
                if online_minutes >= a['parameterA']:
                    self._received_gift_ids.append(a['id'])
                    data = {'online_time': self._online_time,
                            'received_gift_ids': self._received_gift_ids}
                    print 'get gift datetime', data
                    activity.update('online_gift', data)
                else:
                    break
        return False
