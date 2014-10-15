# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity
import time
from shared.db_opear.configs_data.game_configs import activity_config


class CharacterLoginGiftComponent(Component):
    """登录活动"""

    def __init__(self, owner):
        super(CharacterLoginGiftComponent, self).__init__(owner)
        self._continuous_received = []  # 连续登录，已经领过的
        self._cumulative_received = []  # 累积登录，已经领过的
        self._continuous_day = [1, 1]  # [连续登录天数, 是不是首登] 1首登时间内 0 不在时间内
        self._cumulative_day = [1, 1]  # 累积登录天数
        self._last_login = int(time.time())  # 日期

    def init_data(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)
        if activity:
            data = activity.get('login_gift')
            if data:
                # print data, type(data)
                # print time.localtime(data.get('last_login')), type(time.localtime(data.get('last_login')))
                if time.localtime(data.get('last_login')).tm_mday == time.localtime().tm_mday:  # 上次更新是今天
                    self._continuous_received = data.get('continuous_received')
                    self._cumulative_received = data.get('cumulative_received')
                    self._continuous_day = data.get('continuous_day')
                    self._cumulative_day = data.get('cumulative_day')
                else:  # 上次更新不是今天，需要更新活动数据
                    # 累积登录活动
                    cumulative_login_config = activity_config.get(1)[0]  # 新注册用户的累积活动配置
                    if data.get('cumulative_day')[1] and (data.get('cumulative_day')[0]+1) <= cumulative_login_config.get('parameterB'):
                        # 新手累积登录活动
                        self._cumulative_day[0] = data.get('cumulative_day')[0] + 1
                        self._cumulative_day[1] = 1
                        self._cumulative_received = data.get('cumulative_received')
                    else:  # 不是新手活动，S1不做，所以没有更新成不是新手期间
                        self._cumulative_day[0] = data.get('cumulative_day')[0]
                        self._cumulative_day[1] = 1
                        self._cumulative_received = data.get('cumulative_received')

                    continuous_login_config = activity_config.get(2)[0]  # 新注册用户的连续登录活动配置
                    if data.get('continuous_day')[1] and (data.get('continuous_day')[0]+1) <= continuous_login_config.get('parameterB'):
                        # 新手连续登录活动
                        # TODO  判断是不是昨天！！！！！！！！！！！！！！！！！！！！！！！
                        if time.localtime(data.get('last_login')).tm_mday == time.localtime().tm_mday-1:
                            self._continuous_day[0] = data.get('continuous_day')[0] + 1
                            self._continuous_day[1] = 1
                            self._continuous_received = data.get('continuous_received')
                        else:  # 不是昨天
                            self._continuous_day[0] = 1
                            self._continuous_day[1] = 1
                            self._continuous_received = data.get('continuous_received')
                    else:  # 不是新手活动，S1不做，所以没有更新成不是新手期间
                        self._continuous_day[0] = data.get('continuous_day')[0]
                        self._continuous_day[1] = 1
                        self._continuous_received = data.get('continuous_received')
                    self._last_login = int(time.time())

            self.save_data()

        else:
            tb_character_activity.new({'id': self.owner.base_info.id,
                                       'login_gift': {'last_login': int(time.time()),
                                                      'continuous_received': [],
                                                      'cumulative_received': [],
                                                      'continuous_day': [1, 1],
                                                      'cumulative_day': [1, 1]}})

    def save_data(self):
        sign_in_data = tb_character_activity.getObj(self.owner.base_info.id)
        sign_in_data.update('login_gift', {
            'continuous_received': self._continuous_received,
            'cumulative_received': self._cumulative_received,
            'cumulative_day': self._cumulative_day,
            'continuous_day': self._continuous_day,
            'last_login': self._last_login})

    @property
    def continuous_received(self):
        return self._continuous_received

    @continuous_received.setter
    def continuous_received(self, value):
        self._continuous_received = value

    @property
    def cumulative_received(self):
        return self._cumulative_received

    @cumulative_received.setter
    def cumulative_received(self, value):
        self._cumulative_received = value

    @property
    def continuous_day(self):
        return self._continuous_day

    @continuous_day.setter
    def continuous_day(self, value):
        self._continuous_day = value

    @property
    def cumulative_day(self):
        return self._cumulative_day

    @cumulative_day.setter
    def cumulative_day(self, value):
        self._cumulative_day = value

