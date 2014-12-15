#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_client import redis_client
import cPickle
from gfirefly.server.logobj import logger
from shared.utils.pyuuid import get_uuid
from app.world.core.base_boss import BaseBoss
from shared.db_opear.configs_data.game_configs import base_config

class MineBossManager(object):
    """docstring for MineBoss"""
    def __init__(self):
        super(MineBossManager, self).__init__()
        self._bosses = {}  # 所有boss
        self._base_data_name = "mine_boss"
        self._base_demage_name = "MineBossDemage"

    def add(self):
        """docstring for add"""
        boss_id = get_uuid()
        boss_name, boss_demage_name = self.get_boss_name(boss_id)
        Ranking.init(boss_demage_name, 10)
        boss = MineBoss(boss_name, Ranking.instance(boss_demage_name), "mine_boss_stages")
        self._bosses[boss_id] = boss
        return boss_id, boss

    def get_boss_name(self, boss_id):
        """docstring for get_boss_name"""
        boss_name = self._base_data_name + boss_id
        boss_demage_name = self._base_demage_name + boss_id
        return boss_name, boss_demage_name

    def get(self, boss_id):
        return self._bosses.get(boss_id)

    def remove(self, boss_id):
        boss_name, boss_demage_name = self.get_boss_name(boss_id)

    def get_boss_num(self):
        """
        获取boss数量
        """
        return len(self._bosses)


class MineBoss(BaseBoss):
    """随机boss"""
    def __init__(self, boss_name, rank_instance, config_name):
        super(MineBoss, self).__init__(boss_name, rank_instance, config_name)

    def init_data(self):
        """docstring for init_data"""
        str_data = redis_client.get("")
        if not str_data:
            logger.debug("init data...")
            self.update_boss()
            return
        world_boss_data = cPickle.loads(str_data)
        self.init_base_data(world_boss_data)

    def update_boss(self):
        self.update_base_boss(base_config.get("mine_boss"))
        self.save_data()


mine_boss_manager = MineBossManager()
