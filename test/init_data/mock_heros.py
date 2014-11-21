# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from app.game.core.hero import Hero
from app.game.core.PlayersManager import PlayersManager
from shared.db_opear.configs_data.game_configs import hero_config


def init_hero(player):

    for k, val in hero_config.items():
        if val.type == 0:
            hero1 = player.hero_component.add_hero(k)
            hero1.hero_no = k
            hero1.level = 1
            hero1.break_level = 0
            hero1.exp = 0
            hero1.save_data()

    return
    hero1 = player.hero_component.add_hero(10044)
    hero2 = player.hero_component.add_hero(10045)
    hero3 = player.hero_component.add_hero(10046)
    # hero4 = player.hero_component.add_hero(10029)
    # hero5 = player.hero_component.add_hero(10043)
    # hero6 = player.hero_component.add_hero(10062)
    #
    hero1.hero_no = 10044
    hero1.level = 60
    hero1.break_level = 7
    hero1.exp = 0
    hero1.equipment_ids = []

    hero2.hero_no = 10045
    hero2.level = 60
    hero2.break_level = 7
    hero2.exp = 0

    hero3.hero_no = 10046
    hero3.level = 60
    hero3.break_level = 7
    hero3.exp = 0
    #
    # hero4.hero_no = 10029
    # hero4.level = 11
    # hero4.break_level = 1
    # hero4.exp = 1
    # hero4.equipment_ids = []
    #
    # hero5.hero_no = 10043
    # hero5.level = 12
    # hero5.break_level = 2
    # hero5.exp = 2
    # hero5.equipment_ids = []
    #
    # hero6.hero_no = 10062
    # hero6.level = 13
    # hero6.break_level = 3
    # hero6.exp = 3
    # hero6.equipment_ids = []


