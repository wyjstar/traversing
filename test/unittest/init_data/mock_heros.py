# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from app.game.core.hero import Hero
from app.game.core.PlayersManager import PlayersManager


def init_hero():
    hero1 = Hero()
    hero1.hero_no = 10001
    hero1.level = 11
    hero1.break_level = 1
    hero1.exp = 1
    hero1.equipment_ids = []

    hero2 = Hero()
    hero2.hero_no = 10002
    hero2.level = 12
    hero2.break_level = 2
    hero2.exp = 2
    hero2.equipment_ids = []

    hero3 = Hero()
    hero3.hero_no = 10003
    hero3.level = 13
    hero3.break_level = 3
    hero3.exp = 3
    hero3.equipment_ids = []

    player = PlayersManager().get_player_by_id(1)
    player.hero_component.add_hero(hero1)
    player.hero_component.add_hero(hero2)
    player.hero_component.add_hero(hero3)

    print "hero1", hero1.hero_no
    print "hero2", hero2.hero_no
