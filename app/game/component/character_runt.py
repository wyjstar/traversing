# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from app.game.component.Component import Component
from app.game.redis_mode import tb_character_runt
from shared.db_opear.configs_data import game_configs
import random


class CharacterRuntComponent(Component):
    """玩家游历组建
    """

    def __init__(self, owner):
        super(CharacterRuntComponent, self).__init__(owner)
        self._m_runt = {}  # {id, num}
        self._stone1 = 0  # 晶石
        self._stone2 = 0  # 原石
        self._refresh_id = 0  # 刷新石头id
        self._refresh_times = [0, 1]  # 已经使用次数，上次使用时间

    def init_data(self):
        runt_data = tb_character_runt.getObjData(self.owner.base_info.id)
        if runt_data:
            self._m_runt = runt_data.get('m_runt')
            self._stone1 = runt_data.get('stone1')
            self._stone2 = runt_data.get('stone2')
            self._refresh_id = runt_data.get('refresh_id')
            self._refresh_times = runt_data.get('refresh_times')
        else:
            tb_character_runt.new({'id': self.owner.base_info.id,
                                   'm_runt': self._m_runt,
                                   'stone1': self._stone1,
                                   'stone2': self._stone2,
                                   'refresh_id': self.build_refresh(),
                                   'refresh_times': self._refresh_times})

    def save(self):
        data_obj = tb_character_runt.getObj(self.owner.base_info.id)
        data_obj.update_multi({'m_runt': self._m_runt,
                               'stone1': self._stone1,
                               'stone2': self._stone2,
                               'refresh_id': self._refresh_id,
                               'refresh_times': self._refresh_times})

    def build_refresh(self):
        refresh_id = None
        x = random.randint(0, game_configs.stone_config.get('weight')[-1][1])
        flag = 0
        for [stone_id, weight] in game_configs.stone_config.get('weight'):
            if flag <= x < weight:
                refresh_id = stone_id
                break
            flag = weight
        return refresh_id

    def add_runt(self, runt_id, num):
        if len(self._m_runt) + num >= game_configs.base_config.get('totemStash'):
            return 0
        if self._m_runt.get(runt_id):
            self._m_runt[runt_id] += num
        else:
            self._m_runt[runt_id] = num
        return 1

    def reduce_runt(self, runt_id, num):
        if not self._m_runt.get(runt_id) or self._m_runt.get(runt_id) < num:
            return 0
        if self._m_runt.get(runt_id) > num:
            self._m_runt[runt_id] -= num
        else:
            del self._m_runt[runt_id]
        return 1

    @property
    def m_runt(self):
        return self._m_runt

    @m_runt.setter
    def m_runt(self, value):
        self._m_runt = value

    @property
    def stone1(self):
        return self._stone1

    @stone1.setter
    def stone1(self, value):
        self._stone1 = value

    @property
    def stone2(self):
        return self._stone2

    @stone2.setter
    def stone2(self, value):
        self._stone2 = value

    @property
    def refresh_id(self):
        return self._refresh_id

    @refresh_id.setter
    def refresh_id(self, value):
        self._refresh_id = value

    @property
    def refresh_times(self):
        return self._refresh_times

    @refresh_times.setter
    def refresh_times(self, value):
        self._refresh_times = value
