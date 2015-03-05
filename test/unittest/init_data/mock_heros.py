# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from shared.db_opear.configs_data import game_configs
from shared.utils.pyuuid import get_uuid
import random


def init_hero(player):
    # ==========================================

    runts = {}
    d = random.sample(range(1, 11), 2)

    runt_nos = game_configs.stone_config.get('stones').keys()
    for a in xrange(1, 5):
        type_info = {}
        # for b in xrange(1, 11):
        for b in d:
            c = random.randint(0, len(runt_nos)-1)
            runt_id = runt_nos[c]
            main_attr, minor_attr = player.runt.get_attr(runt_id)
            runt_info = [get_uuid(), runt_id, main_attr, minor_attr]

            type_info[b] = runt_info
        runts[a] = type_info

    # ===============================================

    for k, val in game_configs.hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero_without_save(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 0
            hero1.exp = 0

    hero1 = player.hero_component.add_hero_without_save(10045)
    hero1.break_level = 7
    hero1.level = 35
    hero1.runt = runts
    hero1.refine = 1001020
