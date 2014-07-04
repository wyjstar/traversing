# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""

from shared.db_opear.configs_data.game_configs import hero
from gtwisted.utils import log


class Hero(object):
    """武将类"""

    def __init__(self, mmode=None):
        """
        :param mmode: 对应redis中的一条数据
        :field _level: 等级
        :field _break_level: 突破等级
        :field _exp: 当前等级的经验
        :field _equipmentids: 装备IDs
        """

        self._hero_id = ''
        self._hero_no = 0
        self._level = 0
        self._exp = 0
        self._break_level = 0
        self._equipment_ids = []
        self._mmode = mmode

        hero_config = hero.get(self._hero_no)
        if not hero_config:
            log.msg("武将%s配置文件初始化失败！" % self._hero_no)
        self._config = hero_config

    def init_data(self):
        if not self._mmode:
            log.msg("mmode=None 武将初始化数据为空！")
            return
        data = self._mmode.get('data')
        print "武将初始化nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
        print "level", data.get("level")
        print "exp", data.get('exp')
        print "no", data.get("hero_no")
        print data.get("break_level")
        print data.get("equipment_ids")
        self._hero_id = data.get("id")
        self._hero_no = data.get("hero_no")
        self._level = data.get("level")
        self._exp = data.get("exp")
        self._break_level = data.get("break_level")
        self._equipment_ids = data.get("equipment_ids")  # 穿戴装备列表

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
        self._mmode.update('level', value)

    @property
    def exp(self):
        return self._exp

    @exp.setter
    def exp(self, value):
        self._exp = value
        self._mmode.update('exp', self._exp)

    @property
    def break_level(self):
        return self._break_level

    @break_level.setter
    def break_level(self, value):
        self._break_level = value
        self._mmode.update('break_level', self._break_level)

    @property
    def equipment_ids(self):
        return self._equipment_ids

    @equipment_ids.setter
    def equipment_ids(self, value):
        self._equipment_ids = value
        self._mmode.update('equipment_ids', self._equipment_ids)

    @property
    def config(self):
        return self._equipment_ids

    def get_all_exp(self):
        """根据等级+当前等级经验，得到总经验"""
        hero_exp = {}
        total_exp = 0
        for level in range(1, self._level):
            total_exp += hero_exp[level].get('exp', 0)

        return total_exp























