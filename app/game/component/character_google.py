# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
# import time
# from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component


class CharacterRechargeGift(Component):

    def __init__(self, owner):
        super(CharacterRechargeGift, self).__init__(owner)

    def init_data(self, character_info):
        # data = character_info.get('recharge_gift')
        self.check_time()

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

    def check_time(self):
        pass
