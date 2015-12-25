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
import cPickle


class GuildBoss(object):
    """docstring for GuildBoss"""
    def __init__(self):
        self._boss_id = ""
        self._stage_id = 0     # 关卡id
        self._blue_units = {}  # 怪物信息
        self._trigger_time = 0 # 触发时间
        self._hp_max = 0 # 最大血量
        self._boss_type = 0 # boss 类型
        self._trigger_player_id = 0 # 召唤者id
        self._trigger_player_name = "" # 召唤者名字

    def load(self, info):
        """docstring for load"""
        self._stage_id = info.get("stage_id", 0)
        if info.get("blue_units"):
            self._blue_units = cPickle.loads(info.get("blue_units"))
        else:
            self._blue_units = {}
        self._trigger_time = info.get("trigger_time", 0)
        self._hp_max = info.get("hp_max", 0)
        self._boss_type = info.get("boss_type", 0)
        self._trigger_player_id = info.get("trigger_player_id", 0)
        self._trigger_player_name = info.get("trigger_player_name", "")
        self._boss_id = info.get("boss_id", "")

    def property_dict(self):
        data = {
                "stage_id": self._stage_id,
                "blue_units": cPickle.dumps(self._blue_units),
                "trigger_time": self._trigger_time,
                "hp_max": self._hp_max,
                "hp_left": self.hp,
                "boss_type": self._boss_type,
                "trigger_player_id": self._trigger_player_id,
                "trigger_player_name": self._trigger_player_name,
                "boss_id": self._boss_id,
                }
        logger.debug("boss property_dict %s" % data)
        return data

    def check_time(self):
        if not self._stage_id: return
        remain_time = game_configs.base_config.get("AnimalChallengeTime").get(self._stage_id)
        if remain_time + self._trigger_time <= get_current_timestamp():
            self.reset()

    def reset(self):
        self._boss_id = ""
        self._stage_id = 0
        self._trigger_time = 0
        self._hp_max = 0
        self._boss_type = 0
        self._blue_units = {}
        self._trigger_player_id = 0
        self._trigger_player_name = ""

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def boss_type(self):
        return self._boss_type

    @boss_type.setter
    def boss_type(self, value):
        self._boss_type = value

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

    @property
    def trigger_player_id(self):
        return self._trigger_player_id

    @trigger_player_id.setter
    def trigger_player_id(self, value):
        self._trigger_player_id = value

    @property
    def trigger_player_name(self):
        return self._trigger_player_name

    @trigger_player_name.setter
    def trigger_player_name(self, value):
        self._trigger_player_name = value
