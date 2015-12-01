# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午5:22.
"""
import time
from shared.utils.date_util import string_to_timestamp
from shared.utils.random_pick import random_pick_with_weight
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from copy import deepcopy

def update_lucky_hero(lucky_hero_type, difficulty = 0):
    # 初始化幸运武将
    #logger.debug("update lucky hero: start %s, end %s" % (self._lucky_hero_start, self._lucky_hero_end))
    #current = time.time()
    #if not self.is_next_lucky_hero(current):
        #return
    lucky_heros = {}
    hero_infos, lucky_hero_start, lucky_hero_end = get_lucky_hero_items_in_time(lucky_hero_type, difficulty)
    logger.debug("hero_infos %s" % hero_infos)
    for k, hero_info in hero_infos.items():
        hero_pool = deepcopy(hero_info.hero)
        logger.debug("hero_pool1 %s" % hero_pool)
        for _, v in lucky_heros.items():
            hero_no = unicode(v.get('hero_no'))
            if hero_no in hero_pool:
                del hero_pool[hero_no]
        logger.debug("hero_pool2 %s" % hero_pool)
        if len(hero_pool) == 0:
            continue
        res = random_pick_with_weight(hero_pool)
        temp = {}
        temp['lucky_hero_info_id'] = k
        temp['hero_no']  = int(res)
        lucky_heros[hero_info.set] = temp
    return lucky_heros, lucky_hero_start, lucky_hero_end

def get_lucky_hero_items_in_time(lucky_hero_type, difficulty):
    """docstring for get_lucky_hero_items_in_time"""
    items = {}
    current = time.time()
    lucky_hero_start = 0
    lucky_hero_end = 0
    for k, v in game_configs.lucky_hero_config.items():
        if v.Type != lucky_hero_type or v.Difficulty != difficulty: continue

        start = string_to_timestamp(v.timeStart)
        end = string_to_timestamp(v.timeEnd)
        if current > start and current < end:
            items[k] = v
            lucky_hero_start = start
            lucky_hero_end = end
    #if len(items) != 6:
        #logger.error("config error! lucky heros num not enough!")
    return items, lucky_hero_start, lucky_hero_end
