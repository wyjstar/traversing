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
    d = random.sample(range(1, 11), 10)

    #runt_nos = game_configs.stone_config.get('stones').keys()
    runt_nos = [150101, 150201, 150301, 150401]
    #for a in xrange(1, 5):
        #type_info = {}
        ## for b in xrange(1, 11):
        #for b in d:
            #temp = None
            #runt_no = None
            #while a != temp:
                #c = random.randint(0, len(runt_nos)-1)
                #runt_no = runt_nos[c]
                #temp = game_configs.stone_config.get("stones").get(runt_no).get("type")

            #main_attr, minor_attr = player.runt.get_attr(runt_no)
            #runt_info = [get_uuid(), runt_no, main_attr, minor_attr]
            #type_info[b] = runt_info
        #runts[a] = type_info

    # ===============================================
    for k, val in game_configs.hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero_without_save(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 0
            hero1.exp = 0
            hero1.save_data()
    heros = [10045, 10046, 10048, 10053, 10056, 10061]
    for no in heros:
        init_single_hero(player, runts, no)


def init_single_hero(player, runts, hero_no):
    hero1 = player.hero_component.get_hero(hero_no)
    hero1.break_level = 7
    hero1.level = 200
    #hero1.runt = runts
    hero1.refine = 400020
    hero1.save_data()
