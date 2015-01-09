#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.utils.date_util import get_current_timestamp
from shared.utils.date_util import str_time_period_to_timestamp
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_mode import RedisObject
from gfirefly.server.logobj import logger
from app.world.core.base_boss import BaseBoss
from shared.db_opear.configs_data.game_configs import base_config
from gtwisted.core import reactor
import cPickle


tb_mineboss = RedisObject('tb_character_info')


class WorldBoss(BaseBoss):
    """docstring for WorldBoss"""
    def __init__(self, boss_name, rank_instance, config_name):
        super(WorldBoss, self).__init__(boss_name, rank_instance, config_name)
        self._stage_id_am = 0         # 关卡id am
        self._stage_id_pm = 0         # 关卡id pm
        self._state = 0               # boss状态：用于boss到期, 重置状态

        self.init_data()
        self.init_time()
        reactor.callLater(1, self.loop_update)

    def init_data(self):
        """docstring for init_data"""
        str_data = tb_mineboss.get(self._boss_name)
        if not str_data:
            logger.debug("init data...")
            self.update_boss()
            return
        world_boss_data = cPickle.loads(str_data)
        self.init_base_data(world_boss_data)
        self._stage_id_am = world_boss_data.get("stage_id_am")
        self._stage_id_pm = world_boss_data.get("stage_id_pm")

    def init_time(self):
        am_period = self.get_stage_period(self._stage_id_am)
        # pm_period = self.get_stage_period(self._stage_id_pm)

        current = get_current_timestamp()
        if current < am_period[1]:
            self._stage_id = self._stage_id_am
        elif current > am_period[1]:
            self._stage_id = self._stage_id_pm

    def save_data(self):
        base_boss_data = self.get_data_dict()
        world_boss_data = dict(stage_id_am=self._stage_id_am,
                               stage_id_pm=self._stage_id_pm,)
        world_boss_data.update(base_boss_data)
        str_data = cPickle.dumps(world_boss_data)
        tb_mineboss.set(self._boss_name, str_data)

    def loop_update(self):
        if self._stage_id and self.in_the_time_period() and self._state == 0:
            self.start_boss()
            self._state = 1

        if self._stage_id and self._state == 1 and (not self.in_the_time_period()):
            self.update_boss()
            self._state = 0
        reactor.callLater(1, self.loop_update)

    def start_boss(self):
        self._rank_instance.clear_rank()  # 重置排行
        self._last_shot_item = {}  # 重置最后击杀

    def update_boss(self):
        """
        boss被打死或者boss到期后，更新下一个boss相关信息。
        """
        self.set_next_stage(self._hp <= 0)
        self.update_base_boss(base_config.get("world_boss"))

        self.save_data()

        # todo:对前十名发放奖励

    def set_next_stage(self, kill_or_not=False):
        """
        根据id规则确定下一个关卡
        如果boss未被击杀则不升级
        """
        logger.debug("current_stage_id1%s" % self._stage_id)
        current_stage_id = self._stage_id
        if current_stage_id == 0:
            self._stage_id_am = 800101
            self._stage_id_pm = 800102
            self._stage_id = 800101
            return
        if kill_or_not:  # 如果boss被击杀，则升级boss
            if current_stage_id == self._stage_id_am: # am
                self._stage_id_am = current_stage_id + 100
            else:  # pm
                self._stage_id_pm = current_stage_id + 100

        if current_stage_id == self._stage_id_am:
            self._stage_id = self._stage_id_pm
        else:
            self._stage_id = self._stage_id_am

        logger.debug("current_stage_id3%s" % self._stage_id)
        logger.debug("current_stage_id_am%s" % self._stage_id_am)
        logger.debug("current_stage_id_pm%s" % self._stage_id_pm)

    def get_stage_period(self, stage_id):
        """docstring for get_am_period"""
        stage_info = self.get_stage_info(stage_id)
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        return time_start, time_end

    @property
    def open_or_not(self):
        return self.in_the_time_period()


world_boss = WorldBoss("world_boss",
                       Ranking.instance("WorldBossDemage"),
                       "world_boss_stages")
