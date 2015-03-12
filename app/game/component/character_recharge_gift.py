# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import time
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs

RECHARGE_GIFT_TYPE = [7, 8, 9, 10]


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
        self.check_time()

    def new_data(self):
        return {'recharge': self._recharge}

    def check_time(self):
        for activity_id, activity_data in self._recharge.items():
            activity = game_configs.activity_config.get(activity_id)
            if activity is None:
                del self._recharge[activity_id]
                continue
            if not activity.get('is_open'):
                del self._recharge[activity_id]
                continue

    def charge(self, recharge):
        for gift_type in RECHARGE_GIFT_TYPE:
            activitys = game_configs.activity_config.get(gift_type)
            for activity in activitys:
                self.type_process(activity, recharge)

    def type_process(self, activity, recharge):
        activity_id = activity.get('id')
        isopen = activity.get('is_open')
        if isopen != 1:
            logger.debug('activity:%s is not open', activity_id)
            return

        _time_now_struct = time.gmtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _time_now = time.mktime(time.strptime(str_time, '%Y-%m-%d %H:%M:%S'))

        gift_type = activity.get('type')
        if gift_type == 7:  # first time recharge
            if activity_id in self._recharge:
                logger.debug('recharge first is exist:%s:%s',
                             activity_id, self._recharge[activity_id])
            else:
                self._recharge[activity_id] = dict(_time_now=0)

        if gift_type == 8:  # single recharge
            pass

        if gift_type == 9:  # accumulating recharge
            accumulating = 0
            switch = 0
            if activity_id in self._recharge:
                accumulating, switch = self._recharge[activity_id].items()
            accumulating += recharge
            self._recharge[activity_id] = dict(accumulating=switch)

        if gift_type == 10:
            if activity_id in self._recharge:
                self._recharge[activity_id] = {}

            if _time_now not in self._recharge[activity_id]:
                self._recharge[activity_id][_time_now] = 0
