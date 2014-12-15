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
        self._level = level  # 当前等级
        self._exp = exp  # 当前等级获得的经验

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, level):
        self._level = level

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, exp):
        self._exp = exp

    def addexp(self, exp):
        self._exp += exp
        if self._exp > player_exp_config.get(self._level):
            self._exp -= player_exp_config.get(self._level)
            self._level += 1
            MineOpt.update('user_level', self.owner.base_info.id, self._level)