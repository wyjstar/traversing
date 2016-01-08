# -*- coding:utf-8 -*-
"""
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
import time
from shared.db_opear.configs_data import game_configs
from app.game.core.activity import get_act_info
from shared.common_logic.activity import do_get_act_open_info
from gfirefly.server.logobj import logger


WIN_MINE_QUALITY = 1
MIX_RUNT_QUALITY = 1

A_OR_B_TREASURE_QUALITY = 1
A_TREASURE_QUALITY = 1
B_TREASURE_QUALITY = 1
TREASURE_QUALITY = 1
TREASURE_TYPE = 2


class CharacterActComponent(Component):
    """CharacterActComponent"""

    def __init__(self, owner):
        super(CharacterActComponent, self).__init__(owner)
        self._received_ids = {}  # {type:[act_ids]}
        # 状态  1不可领取  2已达成未领取 3已领取 0 未开启
        self._act_infos = {}  # 目标活动信息 {id:[状态，进度]}

    def init_data(self, character_info):
        data = character_info.get('act_info')
        if not data:
            self.new_data()
            return
        self._received_ids = data['received_ids']
        self._act_infos = data['act_infos']
        self.update_51()

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_ids=self._received_ids,
                    act_infos=self._act_infos)
        character_obj.hset('act_info', data)

    def new_data(self):
        data = dict(received_ids={},
                    act_infos=self._act_infos)
        return {'act_info': data}

    def is_activiy_open(self, act_id):
        a = self.get_act_open_info(act_id).get('is_open')
        return a

    def get_act_open_info(self, act_id):
        player_act_type = [3, 6]
        act_conf = game_configs.activity_config.get(act_id)
        if not act_conf:
            return {'is_open': 0, 'time_start': 0, 'time_end': 0}
        register_time = self.owner.base_info.register_time

        if act_conf.duration in player_act_type:
            act_info = self._act_infos.get(act_conf.id)
            if act_info and act_info[0]:
                return {'is_open': 1, 'time_start': 1, 'time_end': 1}
            premise_id = act_conf.premise
            premise_conf = game_configs.activity_config.get(premise_id)
            if not premise_conf or premise_conf.premise == act_id:
                # 防止循环递归
                return {'is_open': 0, 'time_start': 0, 'time_end': 0}
            premise_is_open = self.is_activiy_open(premise_id)
            if not premise_is_open:
                return {'is_open': 0, 'time_start': 0, 'time_end': 0}
            premise_info = get_act_info(self.owner, premise_id)
            if not premise_info.get('state') or premise_info.get('state') == 1:
                return {'is_open': 0, 'time_start': 0, 'time_end': 0}

        return do_get_act_open_info(
            act_id,
            register_time=register_time)

    @property
    def received_ids(self):
        return self._received_ids

    @received_ids.setter
    def received_ids(self, value):
        self._received_ids = value

    @property
    def act_infos(self):
        return self._act_infos

    @act_infos.setter
    def act_infos(self, v):
        self._act_infos = v

    def mine_activity_jindu(self, act_conf):
        """
        获取秘境活动进度
        """
        parameterE = act_conf.parameterE
        act_type = act_conf.type
        if act_type in [56, 58]:
            condition = self._act_infos.get(act_conf.id, 0)
            logger.debug("condition %s" % condition)
            return condition
        elif act_type == 57:
            condition = []
            if self._act_infos.get(act_conf.id):
                condition = self._act_infos.get(act_conf.id)[1]
            logger.debug("condition %s" % condition)

            mine_num = 0
            for temp in condition:
                if temp[WIN_MINE_QUALITY] >= parameterE.get(WIN_MINE_QUALITY, 0):
                    mine_num += 1
            return mine_num
        elif act_type == 59:
            condition = []
            if self._act_infos.get(act_conf.id):
                condition = self._act_infos.get(act_conf.id)[1]
            logger.debug("condition %s" % condition)
            mix_runt_num = 0
            for temp in condition:
                if temp[MIX_RUNT_QUALITY] >= parameterE.get(MIX_RUNT_QUALITY, 0):
                    mix_runt_num += 1
            return mix_runt_num

        logger.debug("mine_activity_jindu act_type %s haven't process!" % act_type)
        return -1

    def condition_update(self, type, v):
        act_ids = game_configs.activity_config.get(type)
        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, v]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    if act_info[1] < v:
                        act_info[1] = v
        self.save_data()

    def condition_add(self, type, v):
        act_ids = game_configs.activity_config.get(type)
        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, v]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1] += v

        if type == 44:
            act_ids = game_configs.activity_config.get(44)
            for act_id in act_ids:
                act_conf = game_configs.activity_config.get(act_id)
                if not self.is_activiy_open(act_id):
                    continue
                act_info = self._act_infos.get(act_id)
                if not act_info:
                    self._act_infos[act_id] = [1, [v, v, 0]]
                else:
                    if act_info[0] != 1:
                        continue
                    else:
                        act_info[1][0] += v
                        act_info[1][1] = max(act_info[1][1], v)
        self.save_data()

    def update_29(self):
        # TODO !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
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
        act_ids = game_configs.activity_config.get(56)
        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, 0]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1] += 1
        self.save_data()

    def mine_win(self, quality):
        """
        秘境占领矿点
        """
        act_ids = game_configs.activity_config.get(57)
        info = {}
        info[WIN_MINE_QUALITY] = quality

        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, [info]]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1].append(info)
        self.save_data()

    def mine_get_runt(self):
        """秘境宝石收取"""
        act_ids = game_configs.activity_config.get(58)
        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, 0]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1] += 1
        self.save_data()

    def mine_mix_runt(self, runt_quality):
        """
        秘境宝石合成
        """
        act_ids = game_configs.activity_config.get(59)
        info = {}
        info[WIN_MINE_QUALITY] = runt_quality

        for act_id in act_ids:
            act_conf = game_configs.activity_config.get(act_id)
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, [info]]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1].append(info)
        logger.debug("mine_mix_runt %s" % infos)
        self.save_data()

    def add_treasure(self, treasure_type, treasure_quality):
        """
        添加宝物或者饰品
        """
        info = {}
        info[TREASURE_TYPE] = treasure_type
        info[TREASURE_QUALITY] = treasure_quality

        for x in [60, 61, 62, 63]:
            act_ids = game_configs.activity_config.get(x)
            for act_id in act_ids:
                act_conf = game_configs.activity_config.get(act_id)
                if not self.is_activiy_open(act_id):
                    continue
                act_info = self._act_infos.get(act_id)
                if not act_info:
                    self._act_infos[act_id] = [1, [info]]
                else:
                    if act_info[0] != 1:
                        continue
                    else:
                        act_info[1].append(info)

        logger.debug("add_treasure %s" % infos)
        self.save_data()

    def treasure_activity_jindu(self, target_conf):
        """
        获取宝物活动进度
        """
        act_type = target_conf.type
        jindu = 0
        parameterE = target_conf.parameterE
        condition = []
        if self._act_infos.get(target_conf.id):
            condition = self._act_infos.get(target_conf.id)[1]
        logger.debug("condition %s" % condition)
        if not condition:
            return jindu

        a_num = 0
        b_num = 0
        a_or_b_num = 0
        for temp in condition:
            print temp, parameterE, '=============================================='
            if temp[TREASURE_QUALITY] >= parameterE.get(A_OR_B_TREASURE_QUALITY, 0):
                a_or_b_num += 1
            if temp[TREASURE_TYPE] == 5 and temp[TREASURE_QUALITY] >= parameterE.get(A_TREASURE_QUALITY, 0):
                a_num += 1
            if temp[TREASURE_TYPE] == 6 and temp[TREASURE_QUALITY] >= parameterE.get(B_TREASURE_QUALITY, 0):
                b_num += 1

        if act_type == 60:
            return a_or_b_num
        elif act_type == 61:
            return a_num
        elif act_type == 62:
            return b_num
        elif act_type == 63:
            return min(a_num, b_num)
        logger.debug("treasure act_type %s haven't process!" % act_type)
        return -1

    def update_51(self):
        _time_now_struct = time.localtime()
        str_time = '%s-%s-%s 00:00:00' % (_time_now_struct.tm_year,
                                          _time_now_struct.tm_mon,
                                          _time_now_struct.tm_mday)
        _date_now = int(time.mktime(time.strptime(str_time,
                                                  '%Y-%m-%d %H:%M:%S')))

        act_confs = game_configs.activity_config.get(51)
        for act_conf in act_confs:
            act_id = act_conf.id
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, [_date_now]]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    if _date_now not in act_info[1]:
                        act_info[1].append(_date_now)
        self.save_data()
