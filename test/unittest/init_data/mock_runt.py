# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:29.
"""

from shared.db_opear.configs_data.game_configs import stone_config


def init_runt(player):
    for k, val in stone_config.get('stones').items():
        player.runt.add_runt(k)
