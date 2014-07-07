# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:32.
"""

from app.game.core.hero import Hero
from test.unittest.init_data.mock_player import player
from app.game.redis_mode import tb_character_hero

data1 = {'hero_no': 10001,
        'character_id': 1, 'level': 11,
        'break_level': 1, 'exp': 1,
        'equipment_ids': []}

mmode1 = tb_character_hero.new(data1)
hero1 = Hero(mmode1)
hero1.init_data()

data2 = {'hero_no': 10002,
        'character_id': 1, 'level': 12,
        'break_level': 2, 'exp': 2,
        'equipment_ids': []}

mmode2 = tb_character_hero.new(data2)
hero2 = Hero(mmode2)
hero2.init_data()

data3 = {'hero_no': 10003,
        'character_id': 1, 'level': 13,
        'break_level': 3, 'exp': 3,
        'equipment_ids': []}

mmode3 = tb_character_hero.new(data3)
hero3 = Hero(mmode3)
hero3.init_data()

player.hero_list.add_hero(hero1)
player.hero_list.add_hero(hero2)
player.hero_list.add_hero(hero3)

print "hero1", hero1.hero_no
print "hero2", hero2.hero_no
