# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午6:44.
"""
from app.game.component.Component import Component
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_activity, tb_character_info
import cPickle


class CharacterSignInComponent(Component):
    """武将碎片组件"""

    def __init__(self, owner):
        super(CharacterSignInComponent, self).__init__(owner)
        self._month = 0  # 当前签到月
        self._sign_in_days = []  # 签到日期
        self._continuous_sign_in_days = 0  # 连续签到天数
        self._continuous_sign_in_prize = []  # 已经获取的连续签到奖励，保存列表[7，15，25]
        self._repair_sign_in_times = 0  # 补充签到次数

    def init_sign_in(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)
        if activity:
            sign_in_data = cPickle.loads(activity.get('sign_in'))
            if sign_in_data:
                self._month = sign_in_data.get('month', 0)
                self._sign_in_days = sign_in_data.get('sign_in_days', [])
                self._continuous_sign_in_days = sign_in_data.get('continuous_sign_in_days', 0)
                self._continuous_sign_in_prize = sign_in_data.get('continuous_sign_in_prize', [])
                self._repair_sign_in_times = sign_in_data.get('repair_sign_in_times', 0)
        else:
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'sign_in': cPickle.dumps({})})

    @property
    def sign_in_days(self):
        return self._sign_in_days

    @sign_in_days.setter
    def sign_in_days(self, value):
        self._sign_in_days = value

    @property
    def continuous_sign_in_days(self):
        return self._continuous_sign_in_days

    @continuous_sign_in_days.setter
    def continuous_sign_in_days(self, value):
        self._continuous_sign_in_days = value

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

    def is_signd(self, month, day):
        """是否已经签到"""
        print "sign_in_days:", self._sign_in_days
        return day in self._sign_in_days and month == self._month

    def sign_in(self, month, day):
        """签到"""
        if self._sign_in_days and month - self._month != 0:
            self._month = month
            self._sign_in_days = []
            self._continuous_sign_in_days = 0

        self._sign_in_days.append(day)
        if not self._sign_in_days or day - self._sign_in_days[-1] == 1:
            self._continuous_sign_in_days += 1

    def save_data(self):
        props = dict(
            month=self._month,
            sign_in_days=self._sign_in_days,
            continuous_sign_in_days=self._continuous_sign_in_days,
            continuous_sign_in_prize=self._continuous_sign_in_prize,
            repair_sign_in_times=self._repair_sign_in_times)

        sign_in_data = tb_character_activity.getObj(self.owner.base_info.id)
        sign_in_data.update('sign_in', cPickle.dumps(props))


