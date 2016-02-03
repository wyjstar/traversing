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
from shared.utils.date_util import get_current_timestamp, days_to_current
from app.proto_file import activity_pb2
from gfirefly.server.globalobject import GlobalObject


remote_gate = GlobalObject().remote.get('gate')


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
        self.update_act()

    def save_data(self):
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        data = dict(received_ids=self._received_ids,
                    act_infos=self._act_infos)
        character_obj.hset('act_info', data)

    def update_act(self):
        self.update_51()
        self.update_act_with_get()
        self.save_data()

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
            premise_info = get_act_info(self.owner, premise_id)
            if premise_info.get('state') != 3:
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
        return None

    def condition_update(self, type, v):
        act_confs = game_configs.activity_config.get(type, [])
        state2_acts = []
        for act_conf in act_confs:
            act_id = act_conf.id
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

            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def condition_add(self, type, v):
        act_confs = game_configs.activity_config.get(type, [])
        state2_acts = []
        for act_conf in act_confs:
            act_id = act_conf.id
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
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)

        if type == 44:
            act_confs = game_configs.activity_config.get(50, [])
            for act_conf in act_confs:
                act_id = act_conf.id
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
                act_info = get_act_info(self.owner, act_conf.id)
                if act_info.get('state') == 2:
                    state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def add_protect_escort_times(self, v):
        self.update_71_73_75(71, v)
        self.update_daily_70_72_74(70, v)
    def add_rob_escort_times(self, v):
        self.update_71_73_75(73, v)
        self.update_daily_70_72_74(72, v)
    def add_guild_boss_times(self, v):
        self.update_71_73_75(75, v)
        self.update_daily_70_72_74(74, v)

    def update_71_73_75(self, type, v):
        state2_acts = []
        act_confs = game_configs.activity_config.get(type, [])
        for act_conf in act_confs:
            act_id = act_conf.id
            if not self.is_activiy_open(act_id):
                continue
            if v not in act_conf.parameterC:
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, 1]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1] += 1
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def update_daily_70_72_74(self, type, v):
        act_confs = game_configs.activity_config.get(type, [])
        state2_acts = []
        for act_conf in act_confs:
            act_id = act_conf.id
            if not self.is_activiy_open(act_id):
                continue
            if v not in act_conf.parameterC:
                continue
            act_info = self._act_infos.get(act_id)

            if not act_info:
                self._act_infos[act_id] = [1, 1, int(time.time())]
            else:
                if days_to_current(act_info[2]) != 0:
                    self._act_infos[act_id] = [1, 1, int(time.time())]
                else:
                    act_info[1] += 1
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
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
        state2_acts = []
        act_confs = game_configs.activity_config.get(56, [])
        for act_conf in act_confs:
            act_id = act_conf.id
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
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def add_currency(self, res_type, num):
        """
        累积消耗货币:元宝，银两，等
        """
        self.update_76_77(76, res_type, num)
        self.update_65(res_type, num)

    def add_pick_card(self, res_type, num):
        """
        抽取武将，神将，良将等
        """
        self.update_76_77(77, res_type, num)

    def update_76_77(self, act_type, res_type, num):
        """docstring for add_times"""
        state2_acts = []
        act_confs = game_configs.activity_config.get(act_type, [])
        for act_conf in act_confs:
            act_id = act_conf.id
            if act_conf.parameterE.items()[0][0] != res_type:
                continue
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, num]
            else:
                if act_info[0] != 1:
                    continue
                else:
                    act_info[1] += num
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def update_65(self, res_type, num):
        """docstring for add_times"""
        act_confs = game_configs.activity_config.get(65, [])
        state2_acts = []
        for act_conf in act_confs:
            act_id = act_conf.id
            if act_conf.parameterE.items()[0][0] != res_type:
                continue
            if not self.is_activiy_open(act_id):
                continue
            act_info = self._act_infos.get(act_id)
            if not act_info:
                self._act_infos[act_id] = [1, num, int(time.time())]
            else:
                if days_to_current(act_info[2]) != 0:
                    self._act_infos[act_id] = [1, num, int(time.time())]
                else:
                    act_info[1] += num
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def mine_win(self, quality):
        """
        秘境占领矿点
        """
        act_confs = game_configs.activity_config.get(57, [])
        print act_confs, '=====================act confs, mine_win'
        info = {}
        info[WIN_MINE_QUALITY] = quality
        state2_acts = []

        for act_conf in act_confs:
            act_id = act_conf.id
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
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def mine_get_runt(self):
        """秘境宝石收取"""
        act_confs = game_configs.activity_config.get(58, [])
        state2_acts = []
        for act_conf in act_confs:
            act_id = act_conf.id
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
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def mine_mix_runt(self, runt_quality):
        """
        秘境宝石合成
        """
        act_confs = game_configs.activity_config.get(59, [])
        info = {}
        info[WIN_MINE_QUALITY] = runt_quality
        state2_acts = []

        for act_conf in act_confs:
            act_id = act_conf.id
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
            act_info = get_act_info(self.owner, act_conf.id)
            if act_info.get('state') == 2:
                state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)
        self.save_data()

    def add_treasure(self, treasure_type, treasure_quality):
        """
        添加宝物或者饰品
        """
        info = {}
        info[TREASURE_TYPE] = treasure_type
        info[TREASURE_QUALITY] = treasure_quality
        state2_acts = []

        for x in [60, 61, 62, 63]:
            act_confs = game_configs.activity_config.get(x, [])
            for act_conf in act_confs:
                act_id = act_conf.id
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
                act_info = get_act_info(self.owner, act_conf.id)
                if act_info.get('state') == 2:
                    state2_acts.append(act_conf.id)
        self.fulfil_activity(state2_acts)

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

        act_confs = game_configs.activity_config.get(51, [])
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

    def update_act_with_get(self):
        for act_conf in game_configs.activity_config.get(1, []):
            if not self.is_activiy_open(act_conf.id):
                continue
            get_act_info(self.owner, act_conf.id)
        for act_conf in game_configs.activity_config.get(18, []):
            if not self.is_activiy_open(act_conf.id):
                continue
            get_act_info(self.owner, act_conf.id)

    def fulfil_activity(self, acts):
        if not acts:
            return
        proto_data = activity_pb2.FulfilActivity()
        for act_id in acts:
            proto_data.act_id.append(act_id)
        if remote_gate and remote_gate.is_connected():
            remote_gate.push_object_remote(1857,
                                           proto_data.SerializeToString(),
                                           [self.owner.dynamic_id])
