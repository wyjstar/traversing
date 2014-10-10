# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午8:04.
"""

from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger


class CharacterLastPickTimeComponent(Component):
    """上次抽取时间"""

    def __init__(self, owner):
        super(CharacterLastPickTimeComponent, self).__init__(owner)
        self._fine_hero = 0  # 良将
        self._excellent_hero = 0  # 神将
        self._fine_equipment = 0  # 良装
        self._excellent_equipment = 0  # 神装

    @property
    def fine_hero(self):
        return self._fine_hero

    @fine_hero.setter
    def fine_hero(self, value):
        self._fine_hero = value

    @property
    def excellent_hero(self):
        return self._excellent_hero

    @excellent_hero.setter
    def excellent_hero(self, value):
        self._excellent_hero = value

    @property
    def fine_equipment(self):
        return self._fine_equipment

    @fine_equipment.setter
    def fine_equipment(self, value):
        self._fine_equipment = value

    @property
    def excellent_equipment(self):
        return self._excellent_equipment

    @excellent_equipment.setter
    def excellent_equipment(self, value):
        self._excellent_equipment = value

    def save_data(self):
        """保存数据
        """
        props = {'fine_hero_last_pick_time': self._fine_hero,
                 'excellent_hero_last_pick_time': self._excellent_hero,
                 'fine_equipment_last_pick_time': self._fine_equipment,
                 'excellent_equipment_last_pick_time': self._excellent_equipment}
        character_obj = tb_character_info.getObj(self.owner.base_info.id)
        character_obj.update_multi(props)

