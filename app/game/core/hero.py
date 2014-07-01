# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""

from shared.db_opear.configs_data.game_configs import all_config_name
from gtwisted.utils import log


class Hero(object):
    """武将类"""

    def __init__(self, data=None):
        """
        :param data: mmode
        :field _level: 等级
        :field _breaklevel: 突破等级
        :field _exp: 当前等级的经验
        :field _equipmentids: 装备IDs
        """
        print "nnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn"
        print "level", data.get("level")
        print "exp", data.get('exp')
        print "no", data.get("hero_no")
        print data.get("break_level")
        print data.get("equipment_ids")
        self._hero_no = data.get("hero_no")
        self._level = data.get("level")
        self._exp = data.get("exp")
        self._breaklevel = data.get("break_level")
        self._equipment_ids = str(data.get("equipment_ids")).split(',')  # 穿戴装备列表

        hero_config = all_config_name['hero'].get(self._hero_no)
        if not hero_config:
            log.msg("武将%s配置文件初始化失败！" % self._hero_no)
        self._config = hero_config

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
    def breaklevel(self):
        return self._breaklevel

    @breaklevel.setter
    def breaklevel(self, value):
        self._breaklevel = value

    @property
    def equipment_ids(self):
        return self._equipment_ids

    @equipment_ids.setter
    def equipment_ids(self, value):
        self._equipment_ids = value

    @property
    def config(self):
        return self._equipment_ids

    @config.setter
    def config(self, value):
        self._config = value




















