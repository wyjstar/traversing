# -*- coding:utf-8 -*-
"""
created by server on 14-7-8上午11:56.
"""
from app.game.component.Component import Component
from shared.db_opear.configs_data.game_configs import player_exp_config
from app.game.component.mine.monster_mine import MineOpt


class CharacterLevelComponent(Component):
    """角色等级组件
    """
    def __init__(self, owner, level=1, exp=0):
        super(CharacterLevelComponent, self).__init__(owner)
