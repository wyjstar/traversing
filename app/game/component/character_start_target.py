# -*- coding:utf-8 -*-
"""
created by cui.
"""
from shared.db_opear.configs_data import game_configs
import time
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger


MINE_REFRESH_TIMES = 1
WIN_MINE_NUM = 2
WIN_MINE_QUALITY = 3
GET_RUNT_TIMES = 4
MIX_RUNT_TIMES = 5
MIX_RUNT_QUALITY = 6
WIN_MINE_INFO = 7
MIX_RUNT_INFO = 8

A_OR_B_TREASURE_NUM = 1
A_OR_B_TREASURE_QUALITY = 2
A_TREASURE_NUM = 3
A_TREASURE_QUALITY = 4
B_TREASURE_NUM = 5
B_TREASURE_QUALITY = 6
TREASURE_TYPE = 7
TREASURE_QUALITY = 8
TREASURE_INFO = 9
        #info[TREASURE_TYPE] = treasure_type
        #info[TREASURE_QUALITY] = treasure_quality
        #infos.append(info)
        #self._conditions[56][TREASURE_INFO] = infos

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

    def mine_refresh(self):
        """
        秘境刷新次数
        """
        if not self.is_open():
            return
        times = self.get_condition(56).get(MINE_REFRESH_TIMES, 0)
        self._conditions[56][MINE_REFRESH_TIMES] = times + 1
        logger.debug("mine_refresh %s" % (times+1))
        self.save_data()

    def mine_win(self, quality):
        """
        秘境占领矿点
        """
        if not self.is_open():
            return
        infos = self.get_condition(56).get(WIN_MINE_INFO, [])
        info = {}
        info[WIN_MINE_QUALITY] = quality
        infos.append(info)
        self._conditions[56][WIN_MINE_INFO] = infos
        logger.debug("mine_win %s" % infos)
        self.save_data()

    def mine_get_runt(self):
        """秘境宝石收取"""
        if not self.is_open():
            return
        times = self.get_condition(56).get(GET_RUNT_TIMES, 0)
        self._conditions[56][GET_RUNT_TIMES] = times + 1
        logger.debug("mine_get_runt %s" % (times+1))
        self.save_data()

    def mine_mix_runt(self, runt_quality):
        """
        秘境宝石合成
        """
        if not self.is_open():
            return
        infos = self.get_condition(56).get(MIX_RUNT_INFO, [])
        info = {}
        info[WIN_MINE_QUALITY] = runt_quality
        infos.append(info)
        self._conditions[56][MIX_RUNT_INFO] = infos
        logger.debug("mine_mix_runt %s" % infos)
        self.save_data()

    def mine_activity_jindu(self, target_conf, act_type):
        """
        获取秘境活动进度
        """
        jindu = 0
        parameterE = target_conf.parameterE
        condition = self._conditions.get(target_conf.type)
        logger.debug("condition %s" % condition)
        if condition:
            return jindu
        mine_refresh_times = condition.get(MINE_REFRESH_TIMES, 0)
        if mine_refresh_times < parameterE.get(MINE_REFRESH_TIMES):
            # 1 秘境刷新次数
            return jindu

        mine_num = 0
        for temp in condition.get(WIN_MINE_INFO, []):
            if temp[WIN_MINE_QUALITY] >= parameterE.get(WIN_MINE_QUALITY):
                mine_num += 1
        if mine_num < parameterE.get(WIN_MINE_NUM):
            # 2 占领矿点数量
            return jindu

        get_runt_times = condition.get(MINE_REFRESH_TIMES)
        if get_runt_times < parameterE.get(GET_RUNT_TIMES):
            # 4 宝石收取次数
            return jindu

        mix_runt_num = 0
        for temp in condition.get(WIN_MINE_INFO, []):
            if temp[WIN_MINE_QUALITY] >= parameterE.get(WIN_MINE_QUALITY):
                mine_num += 1
        if mix_runt_num < parameterE.get(WIN_MINE_NUM):
            # 6 宝石合成品质
            return jindu

        return 1

    def get_condition(self, act_type):
        """docstring for get_condition"""
        if not self._conditions.get(act_type):
            self._conditions[act_type] = {}
        return self._conditions[act_type]


    def add_treasure(self, treasure_type, treasure_quality):
        """
        添加宝物或者饰品
        """
        if not self.is_open():
            return
        infos = self.get_condition(57).get(TREASURE_INFO, [])
        info = {}
        info[TREASURE_TYPE] = treasure_type
        info[TREASURE_QUALITY] = treasure_quality
        infos.append(info)
        self._conditions[57][TREASURE_INFO] = infos
        logger.debug("add_treasure %s" % infos)
        self.save_data()

    def treasure_activity_jindu(self, target_conf, act_type):
        """
        获取宝物活动进度
        """
        jindu = 0
        parameterE = target_conf.parameterE
        condition = self._conditions.get(target_conf.type)
        logger.debug("condition %s" % condition)
        if not condition:
            return jindu

        a_num = 0
        b_num = 0
        a_or_b_num = 0
        for temp in condition.get(TREASURE_INFO, []):
            if temp[TREASURE_QUALITY] >= parameterE.get(A_OR_B_TREASURE_QUALITY, 0):
                a_or_b_num += 1
            if temp[TREASURE_TYPE] == 5 and temp[TREASURE_QUALITY] >= parameterE.get(A_TREASURE_QUALITY, 0):
                a_num += 1
            if temp[TREASURE_TYPE] == 6 and temp[TREASURE_QUALITY] >= parameterE.get(B_TREASURE_QUALITY, 0):
                b_num += 1
        if a_or_b_num < parameterE.get(A_OR_B_TREASURE_NUM, 0) or \
            a_num < parameterE.get(A_TREASURE_NUM, 0) or\
            b_num < parameterE.get(B_TREASURE_NUM, 0):
            return jindu

        return 1
