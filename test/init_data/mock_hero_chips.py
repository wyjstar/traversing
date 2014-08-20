# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from app.game.core.PlayersManager import PlayersManager
from app.game.core.hero_chip import HeroChip
from app.game.redis_mode import tb_character_hero_chip


def init_hero_chip(player):
    hero_chip1 = HeroChip(1010020, 300)
    hero_chip2 = HeroChip(1010021, 300)

    player.hero_chip_component.add_chip(hero_chip1)
    player.hero_chip_component.add_chip(hero_chip2)