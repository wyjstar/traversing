# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
# import time
# from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs

RECHARGE_GIFT_ID = [7001, 8001, 8002, 9001, 9002]


class CharacterRechargeGift(Component):

    def __init__(self, owner):
        super(CharacterRechargeGift, self).__init__(owner)
        self._recharge = {}

    def init_data(self, character_info):
        self._recharge = character_info.get('recharge', {})
        self.check_time()

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        activity.hset('recharge', self._recharge)

    def new_data(self):
        return {'recharge': self._recharge}

    def check_time(self):
        pass

    def charge(self, recharge):
        for gift_id in RECHARGE_GIFT_ID:
            activity = game_configs.activity_config.get(gift_id)
