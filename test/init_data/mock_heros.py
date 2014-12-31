# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from shared.db_opear.configs_data.game_configs import hero_config
from app.game.core.hero import Hero
from app.game.core.PlayersManager import PlayersManager
from shared.db_opear.configs_data.game_configs import hero_config, stone_config
from shared.utils.pyuuid import get_uuid
import random


def init_hero(player):

    # ==========================================

    runts = {}
    d = []
    for _ in range(2):
        while True:
            e = random.randint(1, 10)
            if len(d) == 0 or d[0] != e:
                break
        d.append(e)

    runt_ids = stone_config.get('weight')
    for a in xrange(1, 5):
        type_info = {}
        # for b in xrange(1, 11):
        for b in d:
            c = random.randint(0, len(runt_ids)-1)
            runt_id = runt_ids[c][0]
            main_attr, minor_attr = player.runt.get_attr(runt_id)
            runt_info = [get_uuid(), runt_id, main_attr, minor_attr]

            type_info[b] = runt_info
        runts[a] = type_info

    # hero2.runt = runts

    # ===============================================

    for k, val in hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 0
            hero1.exp = 0
            hero1.save_data()
            print "--*-a-"*40

    hero1 = player.hero_component.add_hero(10045)
    hero1.break_level = 7
    hero1.level = 35
    hero1.refine = 1001020
    hero1.runt = runts
    hero1.save_data()
    return
    hero1 = player.hero_component.add_hero(10044)
    hero2 = player.hero_component.add_hero(10045)
    hero3 = player.hero_component.add_hero(10046)
