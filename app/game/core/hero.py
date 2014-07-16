# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""

from shared.db_opear.configs_data.game_configs import hero_config, hero_exp_config
from gtwisted.utils import log
import cPickle
from app.game.redis_mode import tb_character_hero


class Hero(object):
    """武将类"""

    def __init__(self, character_id=0):
        """
        :field _level: 等级
        :field _break_level: 突破等级
        :field _exp: 当前等级的经验
        :field _equipmentids: 装备IDs
        """
        self._hero_no = 0
        self._level = 0
        self._exp = 0
        self._break_level = 0
        self._character_id = character_id

    def init_data(self, mmode):
        if not mmode:
            return
        data = mmode.get('data')
        print "武将初始化nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
        self._character_id = data.get("character_id")
        hero_property = data.get("property")
        self._hero_no = hero_property.get("hero_no")
        self._level = hero_property.get("level")
        self._exp = hero_property.get("exp")
        self._break_level = hero_property.get("break_level")

    @property
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        self._hero_no = value

    @property
    def level(self):
        return self._level

    @level.setter
    def level(self, value):
        self._level = value

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, value):
        self._exp = value

    @property
    def break_level(self):
        return self._break_level

    @break_level.setter
    def break_level(self, value):
        self._break_level = value

    def get_all_exp(self):
        """根据等级+当前等级经验，得到总经验"""
        total_exp = 0
        for level in range(1, self._level):
            total_exp += hero_exp_config[level].get('exp', 0)

        return total_exp + self._exp

    def upgrade(self, exp):
        """根据经验升级"""
        level = self._level
        temp_exp = self._exp
        temp_exp += exp
        while True:
            current_level_exp = hero_exp_config[level].get('exp', 0)
            if current_level_exp < temp_exp:
                level += 1
                temp_exp -= current_level_exp
            else:
                break

        self.level = level
        self.exp = temp_exp
        self.save_data()
        return level, temp_exp

    def save_data(self):
        hero_id = str(self._character_id) + '_' + str(self._hero_no)
        mmode = tb_character_hero.getObj(hero_id)
        mmode.update('property', self.hero_proerty_dict())

    def hero_proerty_dict(self):
        hero_property = {
            'hero_no': self._hero_no,
            'level': self._level,
            'exp': self._exp,
            'break_level': self._break_level
        }
        return hero_property

    def update_pb(self, hero_pb):
        hero_pb.hero_no = self._hero_no
        hero_pb.level = self._level
        hero_pb.break_level = self._break_level
        hero_pb.exp = self._exp




















