# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from shared.db_opear.configs_data import game_configs


def init_runt(player):
    for k, val in game_configs.stone_config.get('stones').items():
        player.runt.add_runt(k)
    player.runt.save()
