#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
import cPickle
from shared.db_opear.configs_data import game_configs
from shared.utils.date_util import get_current_timestamp
from shared.utils.date_util import str_time_period_to_timestamp
from gfirefly.server.logobj import logger
from gfirefly.dbentrust.redis_mode import RedisObject


tb_hjqyboss = RedisObject('tb_hjqyboss')
class HjqyBossManager(object):
    """
    黄巾起义boss Manager
    """
    def __init__(self):
        self._bosses = {}
        self.init()


    def init(self):
        """docstring for init"""
        boss_data = tb_hjqyboss.hgetall()
        for boss_id, data in boss_data.items():
            boss = HjqyBoss(boss_id)
            boss.init_data(data)
            self._bosses[boss_id] = boss


    def add_boss(self, boss_info):
        """docstring for add_boss"""
        tb_hjqyboss.hsetnx(boss_info['player_id'], boss_info)

    def get_boss(self, player_id):
        """docstring for get_boss"""
        return self._bosses.get(player_id)



class HjqyBoss(object):
    """docstring for Boss"""
    def __init__(self, boss_id):
        self._boss_id = boss_id
        self._stage_id = 0             # 关卡id
        self._blue_units = {}          # 怪物信息


    def init_data(self, data):
        """docstring for init_data"""
        self._stage_id = data.get("stage_id", 0)
        self._blue_units = data.get("blue_units", {})

    @property
    def boss_id(self):
        return self._boss_id

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def hp(self):
        hp = 0
        for unit in self._blue_units.values():
            hp += unit.hp
        return hp

    def get_data_dict(self):
        return dict(boss_id=self._boss_id,
                    blue_units=self._blue_units,
                    stage_id=self._stage_id,)

    def save_data(self):
        """
        保存数据
        """
        tb_hjqyboss.hset(self._boss_id, self.get_data_dict())

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

    def add_rank_item(self, player_info):
        """
        每次战斗结束, 添加排名
        """
        player_id = player_info.get("player_id")

        instance = self._rank_instance
        instance.incr_value(player_id, player_info.get("demage_hp"))

        # 如果玩家信息在前十名，保存玩家信息到redis
        rank_no = instance.get_rank_no(player_id)
        if rank_no > 10:
            return
        logger.debug("player_id, demage_hp, rank_no========= %s, %s, %s" % (player_id, player_info.get("demage_hp"), rank_no))
        str_player_info = cPickle.dumps(player_info)
        self._tb_boss.set(player_id, str_player_info)

    def get_rank_items(self):
        """
        返回伤害最大前十名
        """
        instance = self._rank_instance
        rank_items = []
        for player_id, demage_hp in instance.get(1, 10):
            player_info = cPickle.loads(self._tb_boss.get(player_id))

            player_info["demage_hp"] = demage_hp
            rank_items.append(player_info)

        return rank_items

    def get_rank_item_by_rankno(self, no):
        """
        rank no
        """
        player_id = self._rank_instance.get(no, no)[0][0]
        player_info = cPickle.loads(self._tb_boss.get(player_id))
        return player_info

    def get_demage_hp(self, player_id):
        demage_hp = self._rank_instance.get_value(player_id)
        return demage_hp

    def get_rank_no(self, player_id):
        rank_no = self._rank_instance.get_rank_no(player_id)
        return rank_no

    def current_stage_info(self):
        return game_configs.special_stage_config.get(self._config_name).get(self._stage_id)

    def get_stage_info(self, stage_id):
        return game_configs.special_stage_config.get(self._config_name).get(stage_id)

    def get_hp(self):
        stage_info = self.current_stage_info()
        logger.info("stage info %s id:%s" % (stage_info, self._stage_id))
        monster_group_info = game_configs.monster_group_config.get(stage_info.round1)
        monster_info = game_configs.monster_config.get(monster_group_info.pos5)
        return int(monster_info.hp)
