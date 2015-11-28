#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.db_opear.configs_data import game_configs
from shared.utils.date_util import get_current_timestamp
from shared.utils.date_util import str_time_period_to_timestamp, is_expired
from gfirefly.server.logobj import logger
from gfirefly.dbentrust.redis_mode import RedisObject
from shared.utils.ranking import Ranking
from shared.utils.const import const
from gtwisted.core import reactor
from shared.utils.mail_helper import deal_mail
from gfirefly.server.globalobject import GlobalObject


class GuildBoss(object):
    """docstring for GuildBoss"""
    def __init__(self):
        self._stage_id = 0     # 关卡id
        self._blue_units = {}  # 怪物信息
        self._trigger_time = 0 # 触发时间
        self._hp_max = 0 # 最大血量

    def init_data(self, data):
        """docstring for init_data"""
        self._stage_id = data.get("stage_id", 0)
        self._blue_units = data.get("blue_units", {})
        self._trigger_time = 0 # 触发时间
        self._hp_max = data.get("hp_max", False)

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def trigger_time(self):
        return self._trigger_time

    @trigger_time.setter
    def trigger_time(self, value):
        self._trigger_time = value

    @property
    def blue_units(self):
        return self._blue_units

    @blue_units.setter
    def blue_units(self, value):
        self._blue_units = value

    @property
    def hp(self):
        if self._blue_units.get(5):
            return int(self._blue_units.get(5).hp)
        return 0

    @property
    def hp_max(self):
        return int(self._hp_max)

    @hp_max.setter
    def hp_max(self, value):
        self._hp_max = value

    def get_data_dict(self):
        return dict(player_id=self._player_id,
                    nickname=self._nickname,
                    blue_units=self._blue_units,
                    stage_id=self._stage_id,
                    trigger_time=self._trigger_time,
                    hp_max=self._hp_max,
                    is_share=self._is_share)

    def start_boss(self):
        self._rank_instance.clear_rank()  # 重置排行
        self._last_shot_item = {}  # 重置最后击杀


    def in_the_time_period(self):
        stage_info = self.current_stage_info()
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        current = get_current_timestamp()
        if self._boss_dead_time > time_start:
            return time_start<=current and self._boss_dead_time>=current
        return time_start<=current and time_end>=current

    def get_state(self):
        """
        1: not dead
        2: dead
        3: run away
        """
        if self.hp <= 0:
            return const.BOSS_DEAD
        elif self.is_expired():
            return const.BOSS_RUN_AWAY
        return const.BOSS_LIVE

    def is_expired(self):
        """
        boss 是否逃走
        """
        expired_time = game_configs.base_config.get("hjqyEscapeTime")*60
        return is_expired(self._trigger_time, expired_time)

