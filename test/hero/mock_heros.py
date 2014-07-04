# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from app.game.core.hero import Hero
from test.hero.mock_player import player

hero1 = Hero()

hero1.hero_no = 10001
hero1.break_level = 1
hero1.level = 1
hero1.exp = 1
hero1.equipment_ids = []

hero2 = Hero()

hero1.hero_no = 10002
hero1.break_level = 2
hero1.level = 2
hero1.exp = 2
hero1.equipment_ids = []
player.hero_list.add_hero(hero2)

hero3 = Hero()
hero1.hero_no = 10003
hero1.break_level = 3
hero1.level = 3
hero1.exp = 3
hero1.equipment_ids = []

player.hero_list.add_hero(hero3)
