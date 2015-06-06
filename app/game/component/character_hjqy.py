# -*- coding:utf-8 -*-
"""
created by server on 14-8-29上午11:39.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info


class CharacterHjqyComponent(Component):
    """黄巾起义组件"""

    def __init__(self, owner):
        super(CharacterHjqyComponent, self).__init__(owner)
        self._hjqy = {}

    def init_data(self, character_info):
        self._hjqy = character_info.get('hjqy', {})

    def save_data(self):
        data = tb_character_info.getObj(self.owner.base_info.id)
        data.hset('hjqy', self._hjqy)

    def new_data(self):
        self._hjqy = {'received_ids': [],
                    'last_time': 0
                }
        return {'hjqy': self._hjqy}

    @property
    def received_ids(self):
        received_ids = self._hjqy.get('received_ids', [])
        self._hjqy['received_ids'] = received_ids
        return received_ids

    @received_ids.setter
    def received_ids(self, value):
        self._hjqy['received_ids'] = value

    @property
    def last_time(self):
        return self._hjqy.get('last_time', 0)

    @last_time.setter
    def last_time(self, value):
        self._hjqy['last_time'] = value
