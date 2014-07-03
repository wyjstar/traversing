# -*- coding:utf-8 -*-
"""
created by server on 14-6-20上午10:19.
"""



def load_module():
    from action.node import enter_scene
    from shared.db_opear.configs_data import game_configs

    reload(game_configs)