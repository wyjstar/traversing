# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from test.unittest.init_data.mock_player import player
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_hero_chip

hero_chip1 = HeroChip(1000112, 300)
hero_chip2 = HeroChip(1000114, 300)

data = {'id': 1, 'hero_chips': ''}
tb_character_hero_chip.new(data)

player.hero_chip_list.add_chip(hero_chip1)
player.hero_chip_list.add_chip(hero_chip2)