# -*- coding:utf-8 -*-
"""
created by lucas on 14-11-11下午4:05.
"""
import random
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_brew
from gfirefly.server.logobj import logger
from shared.db_opear.configs_data.game_configs import base_config

# base_config.get('cookingWineOpenLevel')
# base_config.get('cookingWineOutput')
# base_config.get('cookingWineOutputCrit')


class CharacterBrewComponent(Component):
    def __init__(self, owner):
        super(CharacterBrewComponent, self).__init__(owner)
        self._brew_times = 0
        self._brew_date = 0
        self._nectar = 0
        self._nectar_today = base_config.get('cookingWineOutput')

    def init_data(self):
        brew_data = tb_character_brew.getObjData(self.owner.base_info.id)
        if brew_data:
            brew = brew_data.get('brew')
            if brew:
                self._brew_times = brew.get('brew_times')
                self._brew_date = brew.get('brew_data')
                self._nectar = brew.get('nectar')
                self._nectar_today = brew.get('nectar_today')
        else:
            brew = dict(brew_times=self._brew_times,
                        brew_data=self._brew_date,
                        nectar=self._nectar)
            data = dict(brew=brew, hero_refine='')
            tb_character_brew.new(data)

    def save_data(self):
        brew_obj = tb_character_brew.getObj(self.owner.base_info.id)
        if brew_obj:
            brew = dict(brew_times=self._brew_times,
                        brew_data=self._brew_date,
                        nectar=self._nectar,
                        nectar_today=self._nectar_today)
            brew_obj.update('brew', brew)
        else:
            logger.error('cant find brewdata:%s', self.owner.base_info.id)

    def do_brew(self, brew_type):
        if self.owner.level.level < base_config.get('cookingWineOpenLevel'):
            logger.error('char brew level error!!:%s', self.owner.level.level)
            return False

        critical = base_config.get('cookingWineOutputCrit')
        if brew_type not in critical:
            return False
        critical = critical[brew_type]
        rand = random.random()
        for critical_num, rand_range in critical:
            if rand < rand_range:
                self._nectar_today *= critical_num
                break
        self._nectar += self._nectar_today

        return True

    @property
    def nectar(self):
        return self._nectar

    @property
    def brew_times(self):
        return self._brew_times
