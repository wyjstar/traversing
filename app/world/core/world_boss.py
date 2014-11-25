#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.db_opear.configs_data.game_configs import special_stage_config, base_config, hero_config, monster_group_config, monster_config
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_client import redis_client
import random
from shared.utils.random_pick import random_pick_with_percent
from gtwisted.core import reactor
import cPickle
from shared.utils.date_util import str_time_period_to_timestamp, get_current_timestamp
from gfirefly.server.logobj import logger

class WorldBoss(object):
    """docstring for WorldBoss"""
    def __init__(self):
        super(WorldBoss, self).__init__()
        self._lucky_high_heros = []   # 高级幸运武将
        self._lucky_middle_heros = [] # 中级幸运武将
        self._lucky_low_heros = []    # 低级幸运武将
        self._debuff_skill_no = 0     # debuff id
        self._last_shot_item = {}     # 最后击杀
        self._stage_id_am = 0         # 关卡id am
        self._stage_id_pm = 0         # 关卡id pm
        self._stage_id = 0            # 关卡id
        self._hp =0                   # 剩余血量
        self._state = 0               # boss状态：用于boss到期, 重置状态

        self.init_data()
        reactor.callLater(1, self.loop_update)

    def get_hp(self):
        stage_info = self.current_stage_info()
        logger.info("stage info %s id:%s" % (stage_info, self._stage_id))
        monster_group_info = monster_group_config.get(stage_info.round1)
        monster_info = monster_config.get(monster_group_info.pos5)
        return monster_info.hp

    def init_data(self):
        """docstring for init_data"""
        str_data = redis_client.get("world_boss_data")
        if not str_data:
            logger.debug("init data...")
            self.update_boss()
            return
        world_boss_data = cPickle.loads(str_data)
        self._lucky_high_heros = world_boss_data.get("lucky_high_heros")
        self._lucky_middle_heros = world_boss_data.get("lucky_middle_heros")
        self._lucky_low_heros = world_boss_data.get("lucky_low_heros")

        self._debuff_skill_no = world_boss_data.get("debuff_skill_no")
        self._last_shot_item = world_boss_data.get("last_shot_item")
        self._stage_id = world_boss_data.get("stage_id")
        self._stage_id_am = world_boss_data.get("stage_id_am")
        self._stage_id_pm = world_boss_data.get("stage_id_pm")
        self._hp = world_boss_data.get("hp")

    @property
    def stage_id(self):
        return self._stage_id

    @stage_id.setter
    def stage_id(self, value):
        self._stage_id = value

    @property
    def hp(self):
        return self._hp

    def save_data(self):
        world_boss_data = dict(hp=self._hp,
                lucky_high_heros=self._lucky_high_heros,
                lucky_middle_heros=self._lucky_middle_heros,
                lucky_low_heros=self._lucky_low_heros,
                debuff_skill_no=self._debuff_skill_no,
                last_shot_item=self._last_shot_item,
                stage_id=self._stage_id,
                stage_id_am=self._stage_id_am,
                stage_id_pm=self._stage_id_pm
                )
        str_data = cPickle.dumps(world_boss_data)
        redis_client.set("world_boss_data", str_data)

    @property
    def debuff_skill_no(self):
        return self._debuff_skill_no

    @property
    def last_shot_item(self):
        return self._last_shot_item

    @last_shot_item.setter
    def last_shot_item(self, value):
        self._last_shot_item = value

    @property
    def lucky_high_heros(self):
        return self._lucky_high_heros

    @property
    def lucky_middle_heros(self):
        return self._lucky_middle_heros

    @property
    def lucky_low_heros(self):
        return self._lucky_low_heros

    @property
    def open_or_not(self):
        return self.in_the_time_period()

    def loop_update(self):
        if self._stage_id and self.in_the_time_period() and self._state == 0:
            self._state = 1

        if self._stage_id and self._state == 1 and self._hp<=0 and self.in_the_time_period():
            self._state = 2

        if self._stage_id and self._state!=0 and (not self.in_the_time_period()):
            self.update_boss()
            self._state = 0
        reactor.callLater(1, self.loop_update)

    def update_boss(self):
        """
        boss被打死或者boss到期后，更新下一个boss相关信息。
        """
        # 初始化幸运武将
        lucky_hero_1_num = base_config.get("lucky_hero_1_num")
        lucky_hero_2_num = base_config.get("lucky_hero_2_num")
        lucky_hero_3_num = base_config.get("lucky_hero_3_num")
        all_high_heros, all_middle_heros, all_low_heros = self.get_hero_category()
        self._lucky_high_heros =  random.sample(all_high_heros, lucky_hero_1_num)

        for k in self._lucky_high_heros: # 去重
            all_middle_heros.remove(k)
        self._lucky_middle_heros =  random.sample(all_middle_heros, lucky_hero_2_num)

        for k in self._lucky_middle_heros: # 去重
            all_low_heros.remove(k)
        self._lucky_low_heros =  random.sample(all_low_heros, lucky_hero_3_num)

        # 初始化奇遇
        debuff_skill = base_config.get("debuff_skill")
        self._debuff_skill_no = random_pick_with_percent(debuff_skill)

        self.set_next_stage(self._hp<=0)
        self._hp = self.get_hp() # 重置血量
        self.save_data()

        # todo:对前十名发放奖励


    def in_the_time_period(self):
        stage_info = special_stage_config.get("boss_stages").get(self._stage_id)
        time_start, time_end = str_time_period_to_timestamp(stage_info.timeControl)
        current = get_current_timestamp()
        return time_start<=current and time_end>=current

    def get_hero_category(self):
        """docstring for get_hero_category"""
        all_high_heros = []
        all_middle_heros = []
        all_low_heros = []
        for k, v in hero_config.items():
            if v.quality in [5, 6]:
                all_high_heros.append(k)
            if v.quality in [3, 4, 5, 6]:
                all_middle_heros.append(k)
            if v.quality in [2, 3, 4, 5, 6]:
                all_low_heros.append(k)
        return all_high_heros, all_middle_heros, all_low_heros

    def set_next_stage(self, kill_or_not=False):
        """根据id规则确定下一个关卡
        如果boss未被击杀则不升级
        """
        logger.debug("current_stage_id1%s" % self._stage_id)
        current_stage_id = self._stage_id
        if current_stage_id == 0:
            self._stage_id_am = 800101
            self._stage_id_pm = 800102
            self._stage_id = 800101
            return
        if kill_or_not:
            if current_stage_id%10==1: # am
                self._stage_id_am = current_stage_id + 1
            else: # pm
                self._stage_id_pm = current_stage_id + 100 -1

        if current_stage_id%10==1: # am
            self._stage_id = self._stage_id_am
        else: #pm
            self._stage_id = self._stage_id_pm
        logger.debug("current_stage_id3%s" % self._stage_id)
        logger.debug("current_stage_id_am%s" % self._stage_id_am)
        logger.debug("current_stage_id_pm%s" % self._stage_id_pm)


    def current_stage_info(self):
        return special_stage_config.get("boss_stages").get(self._stage_id)

    def add_rank_item(self, player_info):
        """
        每次战斗结束, 添加排名
        """
        player_id = player_info.get("player_id")

        instance = Ranking.instance("WorldBossDemage")
        instance.incr_value(player_id, player_info.get("demage_hp"))

        # 如果玩家信息在前十名，保存玩家信息到redis
        rank_no = instance.get_rank_no(player_id)
        if rank_no > 10: return
        str_player_info = cPickle.dumps(player_info)
        redis_client.set(player_id, str_player_info)

    def get_rank_items(self):
        """
        返回伤害最大前十名
        """
        instance = self.get_rank_instance()
        rank_items = []
        for player_id, demage_hp in instance.get(1, 10):
            player_info = redis_client.get(player_id)
            player_info["demage_hp"] = demage_hp
            rank_items.append(player_info)

        return rank_items

    def get_rank_item_by_rankno(self, no):
        """
        rank no
        """
        instance = self.get_rank_instance()
        player_id = instance.get(no, no)[0][0]

        player_info = redis_client.get(player_id)
        return player_info

    def get_demage_hp(self, player_id):
        demage_hp = self.get_rank_instance().get_value(player_id)
        return demage_hp

    def get_rank_no(self, player_id):
        rank_no = self.get_rank_instance().get_rank_no(player_id)
        return rank_no

    def get_rank_instance(self):
        return Ranking.instance("WorldBossDemage")


world_boss = WorldBoss()
