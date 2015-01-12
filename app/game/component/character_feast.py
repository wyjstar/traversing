# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterFeastComponent(Component):
    """美味酒席组件"""

    def __init__(self, owner):
        super(CharacterFeastComponent, self).__init__(owner)
        self._last_eat_time = 1  # 最后吃酒席的时间戳

    def init_data(self, character_info):
        self._last_eat_time = character_info.get('feast')

    def save_data(self):
        sign_in_data = tb_character_info.getObj(self.owner.base_info.id)
        sign_in_data.hset('feast', self._last_eat_time)

    def new_data(self):
        return {'feast': 1}

    @property
    def last_eat_time(self):
        return self._last_eat_time

    @last_eat_time.setter
    def last_eat_time(self, value):
        self._last_eat_time = value
