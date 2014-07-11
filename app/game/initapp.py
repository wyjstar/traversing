# -*- coding:utf-8 -*-
"""
created by server on 14-6-20上午10:19.
"""


def load_module():
    print '#1 start game conf-----------------------------------'
    from shared.db_opear.configs_data import game_configs
    print '#1 end game conf-----------------------------------'
    from action.node import enter_scene
    from action.node import logout
    from action.node import item
    from action.node import equipment

