# -*- coding:utf-8 -*-
"""
created by server on 14-8-26
"""
import time
from shared.utils.const import const
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import get_return
from app.game.core.item_group_helper import gain

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

    def charge(self, recharge, response):
        for gift_type in RECHARGE_GIFT_TYPE:
            activitys = game_configs.activity_config.get(gift_type)
            if activitys is None:
                logger.debug('activity type is not exist:%s', gift_type)
                continue
            for activity in activitys:
                self.type_process(activity, recharge, response)
        logger.debug(self._recharge)

    def type_process(self, activity, recharge, response):
        activity_id = activity.get('id')
        isopen = activity.get('is_open')
        if isopen != 1:
            logger.debug('activity:%s is not open', activity_id)
            return

        _time_now_struct = time.gmtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _date_now = int(time.mktime(time.strptime(str_time, '%Y-%m-%d %H:%M:%S')))
        _time_now = int(time.time())
        _str_activity_period = activity.get('parameterT')

        if _str_activity_period != '0':
            begin, end = _str_activity_period.split(' - ')
            begin = time.mktime(time.strptime(begin, '%Y-%m-%d %H:%M:%S'))
            end = time.mktime(time.strptime(end, '%Y-%m-%d %H:%M:%S'))

            if _time_now < begin and _time_now > end:
                logger.debug('activity:%s not in time:now%s:begin:%s:end:%s',
                             activity_id, _time_now, begin, end)

        gift_type = activity.get('type')
        if gift_type == 7:  # first time recharge
            if activity_id in self._recharge:
                logger.debug('recharge first is exist:%s:%s',
                             activity_id, self._recharge[activity_id])
            else:
                self._recharge[activity_id] = {_time_now: 0}

        if gift_type == 8:  # single recharge
            if recharge >= activity.get('parameterA'):
                if activity_id not in self._recharge:
                    self._recharge[activity_id] = {}
                if len(self._recharge[activity_id]) < activity.get('repeat') or activity.get('repeat') == -1:
                    self._recharge[activity_id].update({_time_now: recharge})
                else:
                    logger.debug('over activity repeat times:%s(%s)',
                                 self._recharge, activity.get('repeat'))

        if gift_type == 9:  # accumulating recharge
            accumulating = 0
            switch = 0
            if activity_id in self._recharge:
                accumulating, switch = self._recharge[activity_id].items()[0]
            accumulating += recharge
            self._recharge[activity_id] = {accumulating: switch}

        if gift_type == 10:
            if activity_id not in self._recharge:
                self._recharge[activity_id] = {}

            if _date_now not in self._recharge[activity_id].keys():
                self._recharge[activity_id][_date_now] = 0

    def get_data(self, response):
        print self._recharge, type(self._recharge)
        for recharge_id, recharge_data in self._recharge.items():
            activity = game_configs.activity_config.get(recharge_id)
            if activity is None:
                logger.debug('activity id:%s not exist', recharge_id)
                break
            item = response.recharge_items.add()
            item.gift_id = recharge_id
            item.gift_type = activity.get('type')
            for k, v in recharge_data.items():
                _data = item.data.add()
                _data.is_receive = v
                if item.gift_type in [7, 10]:
                    _data.recharge_time = k
                if item.gift_type == 8:
                    _data.recharge_time = k
                    _data.recharge_accumulation = v
                elif item.gift_type == 9:
                    _data.recharge_accumulation = k

    def take_gift(self, recharge_items, response):
        for recharge_item in recharge_items:
            if recharge_item.gift_id not in self._recharge:
                logger.error('recharge id:%s is not exist:%s',
                             recharge_item.gift_id,
                             self._recharge)
                response.res.result = False
                return
            recharge_data = self._recharge[recharge_item.gift_id]
            for data in recharge_item.data:
                if recharge_item.gift_type == 8 and data.recharge_time in recharge_data:
                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_time] = 0
                    if not recharge_data:
                        del self._recharge[recharge_item.gift_id]
                elif data.recharge_time in recharge_data and\
                        recharge_data[data.recharge_time] == 0:
                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_time] = 1
                elif data.recharge_accumulation in recharge_data and\
                        recharge_data[data.recharge_accumulation] == 0:
                    self._get_activity_gift(recharge_item.gift_id, response)
                    recharge_data[data.recharge_accumulation] = 1
                else:
                    response.res.result = False
                    logger.error('error recharge taken:%s:%s', recharge_item,
                                 self._recharge)

        logger.debug(self._recharge)

    def _get_activity_gift(self, activity_id, response):
        activity = game_configs.activity_config.get(activity_id)
        return_data = gain(self.owner, activity.get('reward'),
                           const.RECHARGE)  # 获取
        get_return(self.owner, return_data, response.gain)
