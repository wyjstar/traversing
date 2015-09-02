# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from app.game.core.hero_chip import HeroChip
from shared.db_opear.configs_data import game_configs


def init_hero_chip(player):
    for k, val in game_configs.chip_config.get('chips').items():
        if val.get('type') == 2:
            continue
        chip = HeroChip(int(k), 4000)
        player.hero_chip_component.add_chip(chip)
        player.hero_chip_component.save_data()
    return

    hero_chip1 = HeroChip(1010020, 300)
    hero_chip2 = HeroChip(1010021, 300)

    player.hero_chip_component.add_chip(hero_chip1)
    player.hero_chip_component.add_chip(hero_chip2)
    player.hero_chip_component.save_data()
