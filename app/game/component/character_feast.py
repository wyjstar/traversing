# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_activity, tb_character_info
import cPickle
import time


class CharacterFeastComponent(Component):
    """美味酒席组件"""

    def __init__(self, owner):
        super(CharacterFeastComponent, self).__init__(owner)
        self._last_eat_time = 1  # 最后吃酒席的时间戳

    def init_feast(self):
        activity = tb_character_activity.getObjData(self.owner.base_info.id)
        if activity:
            self._last_eat_time = cPickle.loads(activity.get('feast'))
        else:
            tb_character_activity.new({'id': self.owner.base_info.id, 'sign_in': cPickle.dumps({}), 'feast': 1})

    @property
    def last_eat_time(self):
        return self._last_eat_time

    @last_eat_time.setter
    def last_eat_time(self, value):
        self._last_eat_time = value

    def save_data(self):
        sign_in_data = tb_character_activity.getObj(self.owner.base_info.id)
        sign_in_data.update('feast', int(time.time()))


