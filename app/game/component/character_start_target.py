# -*- coding:utf-8 -*-
"""
created by cui.
"""
from shared.db_opear.configs_data import game_configs
import time
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterStartTargetComponent(Component):
    def __init__(self, owner):
        super(CharacterStartTargetComponent, self).__init__(owner)
        # 状态  1不可领取  2已达成未领取 3已领取
        self._target_info = {}  # 目标活动信息 {id:[状态，进度]}
        self._conditions = {}  # 条件进度{37:1}

    def init_data(self, character_info):
        self._target_info = character_info.get('target_info')
        self._conditions = character_info.get('target_conditions')

    def save_data(self):
        data_obj = tb_character_info.getObj(self.owner.base_info.id)
        data_obj.hmset({'target_info': self._target_info,
                        'target_conditions': self._conditions})

    def new_data(self):
        return {'target_info': self._target_info,
                'target_conditions': self._conditions}

    @property
    def target_info(self):
        return self._target_info

    @target_info.setter
    def target_info(self, v):
        self._target_info = v

    @property
    def conditions(self):
        return self._conditions

    @conditions.setter
    def conditions(self, v):
        self._conditions = v

    def condition_update(self, type, v):
        if self._conditions.get(type) and self._conditions[type] > v:
            return
        else:
            self._conditions[type] = v

    def condition_add(self, type, v):
        if self._conditions.get(type):
            self._conditions[type] += v
        else:
            self._conditions[type] = v

    def is_open(self):
        day = 0

        now = int(time.time())
        register_time = self.owner.base_info.register_time
        act_conf = game_configs.activity_type_config.get(202)
        total_time = int(act_conf.parameterT)
        time.localtime(register_time)

        t0 = time.localtime(now)
        time0 = int(time.mktime(time.strptime(
                    time.strftime('%Y-%m-%d 00:00:00', t0),
                    '%Y-%m-%d %H:%M:%S')))
        t1 = time.localtime(register_time)
        time1 = int(time.mktime(time.strptime(
                    time.strftime('%Y-%m-%d 00:00:00', t1),
                    '%Y-%m-%d %H:%M:%S')))
        day = (time0 - time1)/(24*60*60) + 1

        if act_conf.timeStart > now or now > act_conf.timeEnd:
            logger.debug("202 activity type close by timeStart timeEnd.")
            return 0, day

        if (now - register_time) > (total_time*60*60):
            return 0, day

        return 1, day

    def is_underway(self):
        # 进行中，可以完成
        day = 0
        is_underway = 0
        register_time = self.owner.base_info.register_time
        act_conf = game_configs.activity_type_config.get(202)
        now = int(time.time())

        t0 = time.localtime(now)
        time0 = int(time.mktime(time.strptime(
                    time.strftime('%Y-%m-%d 00:00:00', t0),
                    '%Y-%m-%d %H:%M:%S')))
        t1 = time.localtime(register_time)
        time1 = int(time.mktime(time.strptime(
                    time.strftime('%Y-%m-%d 00:00:00', t1),
                    '%Y-%m-%d %H:%M:%S')))
        day = (time0 - time1)/(24*60*60) + 1

        if act_conf.timeStart > now or now > act_conf.timeEnd:
            logger.debug("202 activity type close by timeStart timeEnd.")
            return 0, day

        if day and day <= 7:
            is_underway = 1
        return is_underway, day

    def update_29(self):
        start_target_is_open, start_target_day = self.is_open()
        if start_target_is_open:
            if self._conditions.get(29):
                self._conditions[29][start_target_day-1] = 1
            else:
                start_target_jindu = [0, 0, 0, 0, 0, 0, 0]
                start_target_jindu[start_target_day-1] = 1
                self._conditions[29] = start_target_jindu
