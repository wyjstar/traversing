# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
import time
from shared.db_opear.configs_data import game_configs
from shared.utils.date_util import days_to_current, get_current_timestamp
from gfirefly.server.logobj import logger


class CharacterLoginGiftComponent(Component):
    """登录活动"""

    def __init__(self, owner):
        super(CharacterLoginGiftComponent, self).__init__(owner)
        self._continuous_day = {}    # 连续登录
        self._cumulative_day = {}    # 累积登录
        self._continuous_7day = {}    # 连续登录7天乐
        self._continuous_day_num = 1 # 连续登录天数
        self._cumulative_day_num = 1 # 累积登录天数
        self._continuous_7day_num = 1 # 连续登录天数7天乐
        self.new_item()
        self._last_login = int(time.time())  # 日期

    def init_data(self, character_info):
        logger.debug("login_gift_init_data===========")
        data = character_info.get('login_gift')
        self._continuous_day = data.get('continuous_day', {})
        self._continuous_day_num = data.get('continuous_day_num', 0)
        self._continuous_7day = data.get('continuous_7day', {})
        self._continuous_7day_num = data.get('continuous_7day_num', 0)
        self._cumulative_day_num = data.get('cumulative_day_num', 0)
        self._cumulative_day = data.get('cumulative_day', {})
        self._last_login= data.get('last_login')
        self.check_time()

    def new_item(self):
        """docstring for new_item"""
        activity_infos = game_configs.activity_config.get(2, [])
        for info in activity_infos:
            self._continuous_day[info.id] = -1

        activity_infos = game_configs.activity_config.get(1, [])
        for info in activity_infos:
            self._cumulative_day[info.id] = -1

        activity_infos = game_configs.activity_config.get(18, [])
        for info in activity_infos:
            self._continuous_7day[info.id] = -1

        self._continuous_day[2001] = 0
        self._cumulative_day[1001] = 0
        self._continuous_7day[18001] = 0

    def check_time(self):
        """docstring for check_time"""

        logger.debug("login_time================== %s" % days_to_current(self._last_login))

        if days_to_current(self._last_login) > 1 and self.is_open(2001):
            activity_infos = game_configs.activity_config.get(2, [])
            for info in activity_infos:
                if not self.is_open(info.id):
                    self._continuous_day[info.id] = -1
            self._continuous_day[2001] = 0
            self._continuous_day_num = 1

        if days_to_current(self._last_login) > 1 and self.is_open(18001):
            # 7天乐
            activity_infos = game_configs.activity_config.get(18, [])
            for info in activity_infos:
                self._continuous_7day[info.id] = -1
            self._continuous_7day[18001] = 0
            self._continuous_7day_num = 1


        elif days_to_current(self._last_login) == 1 and self.is_open(2001):
            self._continuous_day_num += 1
            for k in sorted(self._continuous_day.keys()):
                v = self._continuous_day[k]
                activity_info = game_configs.activity_config.get(k, [])
                if v == -1 or activity_info.parameterA == 7:
                    self._continuous_day[k] = 0
                    break

        if days_to_current(self._last_login) > 1 and self.is_open(18001):
            # 7天乐
            self._continuous_7day_num += 1
            for k in sorted(self._continuous_7day.keys()):
                v = self._continuous_7day[k]
                activity_info = game_configs.activity_config.get(k, [])
                if v == -1:
                    self._continuous_7day[k] = 0
                    break

        if days_to_current(self._last_login) > 0 and self.is_open(1001):
            self._cumulative_day_num+= 1
            for k in sorted(self._cumulative_day.keys()):
                v = self._cumulative_day[k]
                if v == -1:
                    self._cumulative_day[k] = 0
                    break

        #activity_infos = game_configs.activity_config.get(2, [])
        #days_to_register = days_to_current(self._owner.base_info.register_time)
        #if activity_infos and days_to_register >= activity_infos[0].parameterB:
            #self._cumulative_day_num = -1

        #activity_infos = game_configs.activity_config.get(18, [])
        #if activity_infos and days_to_register >= activity_infos[0].parameterB:
            #self._continuous_7day_num = -1

        self._last_login = get_current_timestamp()
        self.save_data()

    def save_data(self):
        sign_in_data = tb_character_info.getObj(self.owner.base_info.id)
        sign_in_data.hset('login_gift', {
            'cumulative_day': self._cumulative_day,
            'continuous_day': self._continuous_day,
            'continuous_day_num': self._continuous_day_num,
            'cumulative_day_num': self._cumulative_day_num,
            'continuous_7day': self._continuous_7day,
            'continuous_7day_num': self._continuous_7day_num,
            'last_login': self._last_login})

    def new_data(self):
        return {'login_gift': {'last_login': self._last_login,
                               'continuous_day': self._continuous_day,
                               'continuous_day_num': self._continuous_day_num,
                               'continuous_7day': self._continuous_7day,
                               'continuous_7day_num': self._continuous_7day_num,
                               'cumulative_day_num': self._cumulative_day_num,
                               'cumulative_day': self._cumulative_day}}

    @property
    def continuous_day(self):
        return self._continuous_day

    @continuous_day.setter
    def continuous_day(self, value):
        self._continuous_day = value

    @property
    def continuous_7day(self):
        return self._continuous_7day

    @continuous_7day.setter
    def continuous_7day(self, value):
        self._continuous_7day = value

    @property
    def cumulative_day(self):
        return self._cumulative_day

    @cumulative_day.setter
    def cumulative_day(self, value):
        self._cumulative_day = value

    @property
    def cumulative_day_num(self):
        return self._cumulative_day_num

    @cumulative_day_num.setter
    def cumulative_day_num(self, value):
        self._cumulative_day_num = value

    @property
    def continuous_day_num(self):
        return self._continuous_day_num

    @continuous_day_num.setter
    def continuous_day_num(self, value):
        self._continuous_day_num = value

    @property
    def continuous_7day_num(self):
        return self._continuous_7day_num

    @continuous_7day_num.setter
    def continuous_7day_num(self, value):
        self._continuous_7day_num = value

    def is_open(self, activity_id):
        """
        check if it opened.
        """
        activity_info = game_configs.activity_config.get(activity_id)
        if not activity_info:
            logger.error("can not find activity_config by id %s" % activity_id)
            return False
        if not self._owner.act.is_activiy_open(activity_id):
            return False
        if activity_info.type == 1:
            # 累积七天后关闭
            res = False
            for k, v in self._cumulative_day.items():
                if v != 1:
                    res = True
            return res
        return True
