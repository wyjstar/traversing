# -*- coding:utf-8 -*-
'''
Created on 2014-11-27

@author: hack
'''
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_info
from gfirefly.server.logobj import logger


class UserStone(Component):
    def __init__(self, owner):
        self._update = True
        Component.__init__(self, owner)
        self._stones = {}

    def init_data(self, character_info):
        mine = character_info.get('stones')
        all_stones = mine.get('1')
        if all_stones:
            self._stones = all_stones
        else:
            self._stones = {}

    def save_data(self):
        mine_obj = tb_character_info.getObj(self.owner.base_info.id)
        if mine_obj:
            data = {'stones': {'1': self._stones}}
            mine_obj.hmset(data)
        else:
            logger.error('cant find mine:%s', self.owner.base_info.id)

    def new_data(self):
        return dict(stones={'1': self._stones})

    def is_full(self, stype):
        pass

    def add_stones(self, stype, num):
        if stype not in self._stones:
            self._stones[stype] = num
        else:
            self._stones[stype] += num
        self._update = True
