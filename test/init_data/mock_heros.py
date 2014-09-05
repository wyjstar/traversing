# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from app.game.core.hero import Hero
from app.game.core.PlayersManager import PlayersManager


def init_hero(player):

    hero1 = player.hero_component.add_hero(10005)
    hero2 = player.hero_component.add_hero(10015)
    hero3 = player.hero_component.add_hero(10022)
    hero4 = player.hero_component.add_hero(10029)
    hero5 = player.hero_component.add_hero(10043)
    hero6 = player.hero_component.add_hero(10062)

    hero1.hero_no = 10005
    hero1.level = 11
    hero1.break_level = 1
    hero1.exp = 1
    hero1.equipment_ids = []

    hero2.hero_no = 10015
    hero2.level = 12
    hero2.break_level = 2
    hero2.exp = 2
    hero2.equipment_ids = []

    hero3.hero_no = 10022
    hero3.level = 13
    hero3.break_level = 3
    hero3.exp = 3
    hero3.equipment_ids = []

    hero4.hero_no = 10029
    hero4.level = 11
    hero4.break_level = 1
    hero4.exp = 1
    hero4.equipment_ids = []

    hero5.hero_no = 10043
    hero5.level = 12
    hero5.break_level = 2
    hero5.exp = 2
    hero5.equipment_ids = []

    hero6.hero_no = 10062
    hero6.level = 13
    hero6.break_level = 3
    hero6.exp = 3
    hero6.equipment_ids = []


