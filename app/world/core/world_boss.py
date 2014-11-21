#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from shared.db_opear.configs_data.game_configs import special_stage_config, base_config, hero_config
from shared.utils.ranking import Ranking
from gfirefly.dbentrust.redis_client import redis_client
import random
from shared.utils.random_pick import random_pick_with_percent
from gtwisted.core import reactor
from datetime import datetime
import cPickle

class WorldBoss(object):
    """docstring for WorldBoss"""
    def __init__(self):
        super(WorldBoss, self).__init__()
        self._hp = 0
        self._lucky_high_heros = []
        self._lucky_middle_heros = []
        self._lucky_low_heros = []
        self._debuff_skill_no = 0
        self._rank_items = []
        self._last_shot_item = None
        self._stage_id = 800101
        self._update_time = datetime(1,1,1)
        self._open_or_not = False
        reactor.callLater(1, self.loop_update)

    @property
    def hp(self):
        return self._hp

    @hp.setter
    def hp(self, value):
        self._hp = value

    def save_data(self):
        world_bass_data = dict(hp=self._hp,
                lucky_high_heros=self._lucky_high_heros,
                lucky_middle_heros=self._lucy_middle_heros,
                lucky_low_heros=self._lucky_low_heros,
                debuff_skill_no=self._debuff_skill_no,
                rank_items=self._rank_items,
                last_shot_item=self._last_shot_item,
                stage_id=self._stage_id,
                update_time=self._update_time,
                open_or_not=self._open_or_not)
        redis_client.set("world_bass_data", world_bass_data)

    @property
    def debuff_skill_no(self):
        return self._debuff_skill_no

    @debuff_skill_no.setter
    def debuff_skill_no(self, value):
        self._debuff_skill_no = value

    @property
    def rank_items(self):
        return self._rank_items

    @rank_items.setter
    def rank_items(self, value):
        self._rank_items = value

    @property
    def last_shot_item(self):
        return self._last_shot_item

    @last_shot_item.setter
    def last_shot_item(self, value):
        self._last_shot_item = value

    @property
    def lucky_high_heros(self):
        return self._lucky_high_heros

    @lucky_high_heros.setter
    def lucky_high_heros(self, value):
        self._lucky_high_heros = value

    @property
    def lucky_middle_heros(self):
        return self._lucky_middle_heros

    @lucky_middle_heros.setter
    def lucky_middle_heros(self, value):
        self._lucky_middle_heros = value

    @property
    def lucky_low_heros(self):
        return self._lucky_low_heros

    @lucky_low_heros.setter
    def lucky_low_hero(self, value):
        self._lucky_low_heros = value

    def loop_update(self):
        self.init_boss()
        reactor.callLater(1, self.loop_update)

    def get_current_date(self):
        """docstring for get_current_date"""
        now = datetime.now()
        return datetime(now.year, now.month, now.day)

    def init_boss(self):
        """
        初始化boss相关信息。
        """
        now = self.get_current_date()
        if now > self._update_time:
            self._update_time = now
        else:
            return

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
        self._lucky_middle_heros =  random.sample(all_low_heros, lucky_hero_3_num)

        # 初始化奇遇
        debuff_skill = base_config.get("debuff_skill")
        self._debuff_skill_no = random_pick_with_percent(debuff_skill)


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

    def begin_fight(self):

        pass

    def add_rank_item(self, rank_item):
        """
        每次战斗结束, 添加排名
        """
        rank_item = cPickle.dumps(rank_item)
        instance = Ranking.instance("WorldBossDemage")
        instance.add(rank_item, rank_item.demage_hp)

    def get_rank_items(self):
        """
        返回伤害最大前十名
        """
        instance = Ranking.instance("WorldBossDemage")
        return instance.get(10)


world_boss = WorldBoss()

class RankItem(object):
    """docstring for RankItem"""
    def __init__(self):
        super(RankItem, self).__init__()



