# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:44.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger
from shared.utils.date_util import days_to_current
from shared.db_opear.configs_data import game_configs


class CharacterSignInComponent(Component):

    def __init__(self, owner):
        super(CharacterSignInComponent, self).__init__(owner)
        self._sign_round = 1  # 当前签到月
        self._sign_in_days = []  # 签到日期
        self._continuous_sign_in_prize = []  # 已经获取的累积签到奖励，保存列表[7，15，25]
        self._repair_sign_in_times = 0  # 补充签到次数
        self._box_sign_in_prize = []  # 已经获取的宝箱签到奖励，保存列表activity_config id

    def init_data(self, character_info):
        sign_in_data = character_info.get('sign_in')
        self._sign_round = sign_in_data.get('sign_round')
        self._sign_in_days = sign_in_data.get('sign_in_days')
        self._continuous_sign_in_prize = sign_in_data.get('continuous_sign_in_prize')
        self._repair_sign_in_times = sign_in_data.get('repair_sign_in_times')
        self._box_sign_in_prize = sign_in_data.get('box_sign_in_prize')

    def save_data(self):
        props = dict(
            sign_round=self._sign_round,
            sign_in_days=self._sign_in_days,
            continuous_sign_in_prize=self._continuous_sign_in_prize,
            box_sign_in_prize=self._box_sign_in_prize,
            repair_sign_in_times=self._repair_sign_in_times)

        sign_in_data = tb_character_info.getObj(self.owner.base_info.id)
        sign_in_data.hset('sign_in', props)

    def new_data(self):
        props = dict(
            sign_round=self._sign_round,
            sign_in_days=self._sign_in_days,
            continuous_sign_in_prize=self._continuous_sign_in_prize,
            repair_sign_in_times=self._repair_sign_in_times,
            box_sign_in_prize=self._box_sign_in_prize
        )
        return {'sign_in': props}

    @property
    def sign_in_days(self):
        return self._sign_in_days

    @sign_in_days.setter
    def sign_in_days(self, value):
        self._sign_in_days = value

    @property
    def sign_round(self):
        return self._sign_round

    @sign_round.setter
    def sign_round(self, value):
        self._sign_round = value

    def current_day(self):
        return days_to_current(self.owner.base_info.register_time) % 30 + 1

    @property
    def continuous_sign_in_prize(self):
        return self._continuous_sign_in_prize

    @continuous_sign_in_prize.setter
    def continuous_sign_in_prize(self, value):
        self._continuous_sign_in_prize = value

    @property
    def repair_sign_in_times(self):
        return self._repair_sign_in_times

    @repair_sign_in_times.setter
    def repair_sign_in_times(self, value):
        self._repair_sign_in_times = value

    def is_signd(self, day):
        """是否已经签到"""
        logger.info("sign_in_days:%s", self._sign_in_days)
        return day in self._sign_in_days

    def sign_in(self, day):
        """签到"""
        self._sign_in_days.append(day)

    def clear_sign_days(self):
        """docstring for clear_sign_days"""
        sign_round = days_to_current(self.owner.base_info.register_time) / 30 + 1
        if self._sign_in_days and sign_round - self._sign_round != 0:
            self._sign_round = sign_round
            self._sign_in_days = []
            self._continuous_sign_in_prize = []
            self._repair_sign_in_times = 0
            self._box_sign_in_prize = []
        self.save_data()

    def get_sign_in_reward(self, num):
        for v in game_configs.activity_config[6]:
            if v.parameterA == num and self._sign_round == v.parameterB:
                return v.reward, v.id
        logger.error("can not find reward!")

    @property
    def box_sign_in_prize(self):
        return self._box_sign_in_prize

    @box_sign_in_prize.setter
    def box_sign_in_prize(self, value):
        self._box_sign_in_prize = value

