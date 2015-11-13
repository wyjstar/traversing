# -*- coding:utf-8 -*-
"""
created by sphinx on 15-11-11
"""
import time
from gfirefly.server.logobj import logger
from app.game.redis_mode import tb_character_info
from app.game.component.Component import Component
from shared.db_opear.configs_data import game_configs


class CharacterFundActivity(Component):

    def __init__(self, owner):
        super(CharacterFundActivity, self).__init__(owner)
        self._data = {}
        self._precondition = {}

    def init_data(self, character_info):
        fund_data = character_info.get('fund_activity', {})
        self._data = fund_data.get('data', {})
        self._precondition = fund_data.get('precondition', {})
        self.check_time()
        self.check_precondition()
        print 'data==========', self._data
        print 'precondition==========', self._precondition

    def save_data(self):
        activity = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(data=self._data,
                    precondition=self._precondition)
        activity.hset('fund_activity', data)

    def new_data(self):
        data = dict(data=self._data,
                    precondition=self._precondition)
        return {'fund_activity': data}

    def check_time(self):
        _time_now_struct = time.localtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _date_now = int(time.mktime(time.strptime(str_time,
                                                  '%Y-%m-%d %H:%M:%S')))

        for act_item in game_configs.activity_config[50]:
            if act_item.get('id') not in self._precondition and \
                    self.owner.base_info.is_activiy_open(act_item.get('id')):
                act_data = dict(recharge=0,
                                max_single_recharge=0,
                                consume=0)
                self._precondition[act_item.get('id')] = act_data

        for aid in self._precondition.keys():
            if not self.owner.base_info.is_activiy_open(aid):
                logger.info('pre activity id:%s is close', aid)
                del self._precondition[aid]

        for act_item in game_configs.activity_config[51]:
            if act_item.get('id') not in self._data and \
                    self.owner.base_info.is_activiy_open(act_item.get('id')):
                act_data = dict(is_open=False,
                                state=0,
                                accumulate_days=[])
                self._data[act_item.get('id')] = act_data

        for aid in self._data.keys():
            if not self.owner.base_info.is_activiy_open(aid):
                logger.info('activity id:%s is close', aid)
                del self._data[aid]
            if self._data[aid]['is_open'] is True:
                set_date = set(self._data[aid]['accumulate_days'])
                set_date.add(_date_now)
                self._data[aid] = list(set_date)
        self.save_data()

    def check_precondition(self):
        print self._precondition
        for k, v in self._precondition.items():
            act_item = game_configs.activity_config[k]
            if act_item.parameterB < v['consume']:
                continue
            # base_info = self.owner.base_info
            # if int(act_item.parameterA) > base_info.vip_level:
            #     continue
            if act_item.premise != 0:
                act_item2 = game_configs.activity_config.get(act_item.premise)
                if act_item2 is None:
                    logger.error('cant find activity premise act:%s',
                                 act_item.premise)
                    continue
                if int(act_item2.get('parameterA')) > v['recharge']:
                    continue
            if len(act_item.parameterD) == 1 and \
                    act_item.parameterD[0] > v['max_single_recharge']:
                continue
            self.activate(act_item.get('id'))

    def activate(self, aid):
        logger.debug('fund activity activated:%s', aid)
        for k, v in self._data.items():
            act_item = game_configs.activity_config.get(k)
            if act_item is None:
                continue
            if act_item.get('premise') == aid:
                v['is_open'] = True

    def recharge(self, num):
        for k, v in self._precondition.items():
            v['recharge'] += num
            v['max_single_recharge'] = max(num, v['max_single_recharge'])

    @property
    def fund_info(self):
        self.check_precondition()
        return self._data

    @property
    def precondition(self):
        self.check_precondition()
        return self._precondition
