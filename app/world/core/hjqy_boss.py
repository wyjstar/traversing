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


tb_hjqyboss = RedisObject('tb_hjqyboss')
tb_hjqyboss_player = RedisObject('tb_hjqyboss_player')
class HjqyBossManager(object):
    """
    黄巾起义boss Manager
    """
    def __init__(self, _tb_hjqyboss, _tb_hjqyboss_player):
        self._bosses = {}
        self.init()
        self._tb_hjqyboss = _tb_hjqyboss
        self._tb_hjqyboss_player = _tb_hjqyboss_player

    def init(self):
        """docstring for init"""
        boss_data = self._tb_hjqyboss.hgetall()
        for boss_id, data in boss_data.items():
            boss = HjqyBoss(boss_id)
            boss.init_data(data)
            self._bosses[boss_id] = boss
        self._rank_instance = Ranking.instance("HjqyBossDamage")


    def add_boss(self, player_id, blue_units, stage_id):
        """docstring for add_boss"""
        boss = HjqyBoss(player_id, self._tb_hjqyboss)
        boss.blue_units = blue_units
        boss.stage_id = stage_id
        boss.trigger_time = int(get_current_timestamp())
        self._bosses[player_id] = boss
        boss.save_data()

    def get_boss(self, player_id):
        """docstring for get_boss"""
        boss = self._bosses.get(player_id)
        if not boss:
            logger.error("boss %s not exists." % player_id)
        return boss

    def add_rank_item(self, player_info):
        player_id = player_info.get("player_id")

        instance = self._rank_instance
        instance.incr_value(player_id, player_info.get("damage_hp"))

        # 如果玩家信息在前十名，保存玩家信息到redis
        rank_no = instance.get_rank_no(player_id)
        if rank_no > 10:
            return
        logger.debug("player_id, damage_hp, rank_no========= %s, %s, %s" % (player_id, player_info.get("damage_hp"), rank_no))
        str_player_info = player_info
        self._tb_hjqyboss_player.set(player_id, str_player_info)

    def get_rank_items(self):
        """
        返回伤害最大前十名
        """
        instance = self._rank_instance
        rank_items = []
        for rank, v in enumerate(instance.get(1, 10)):
            player_id = v[0]
            damage_hp = v[1]
            player_info = self._tb_hjqyboss.get(player_id)
            player_info["rank"] = rank
            player_info["damage_hp"] = damage_hp
            rank_items.append(player_info)

        return rank_items

    def get_damage_hp(self, player_id):
        damage_hp = self._rank_instance.get_value(player_id)
        return damage_hp

    def get_rank(self, player_id):
        rank = self._rank_instance.get_rank_no(player_id)
        return rank


class HjqyBoss(object):
    """docstring for Boss"""
    def __init__(self, player_id):
        self._player_id = player_id
        self._stage_id = 0     # 关卡id
        self._blue_units = {}  # 怪物信息
        self._is_share = False # 是否已经分享


    def init_data(self, data):
        """docstring for init_data"""
        self._stage_id = data.get("stage_id", 0)
        self._blue_units = data.get("blue_units", {})
        self._is_share = data.get("is_share", False)

    @property
    def player_id(self):
        return self._player_id

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def is_share(self):
        return self._is_share

    @is_share.setter
    def is_share(self, value):
        self._is_share = value

    @property
    def hp(self):
        hp = 0
        for unit in self._blue_units.values():
            hp += unit.hp
        return hp

    @property
    def hp_max(self):
        hp_max = 0
        for unit in self._blue_units.values():
            hp_max += unit.hp_max
        return hp_max

    def get_data_dict(self):
        return dict(boss_id=self._boss_id,
                    blue_units=self._blue_units,
                    stage_id=self._stage_id,
                    is_share=self._is_share)

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

    def send_rank_reward_mails(self):
        """
        排行奖励
        """
        pass
    #def get_rank_item_by_rankno(self, no):
        #"""
        #rank no
        #"""
        #player_id = self._rank_instance.get(no, no)[0][0]
        #player_info = cPickle.loads(self._tb_boss.get(player_id))
        #return player_info

    #def get_demage_hp(self, player_id):
        #demage_hp = self._rank_instance.get_value(player_id)
        #return demage_hp

    #def get_rank_no(self, player_id):
        #rank_no = self._rank_instance.get_rank_no(player_id)
        #return rank_no

    #def current_stage_info(self):
        #return game_configs.special_stage_config.get(self._config_name).get(self._stage_id)

    #def get_stage_info(self, stage_id):
        #return game_configs.special_stage_config.get(self._config_name).get(stage_id)

    #def get_hp(self):
        #stage_info = self.current_stage_info()
        #logger.info("stage info %s id:%s" % (stage_info, self._stage_id))
        #monster_group_info = game_configs.monster_group_config.get(stage_info.round1)
        #monster_info = game_configs.monster_config.get(monster_group_info.pos5)
        #return int(monster_info.hp)

hjqy_manager = HjqyBossManager(tb_hjqyboss)
