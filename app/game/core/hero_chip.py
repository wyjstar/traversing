# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午8:06.
"""
from shared.db_opear.configs_data.game_configs import all_config_name
from gtwisted.utils import log


class HeroChip(object):
    """武将碎片"""
    def __init__(self, data=None):
        self._chip_no = data.get('hero_chip_no')
        self._num = data.get('num')
        chip_config = all_config_name['hero_chip_config'].get(self._chip_no)
        if not chip_config:
            log.msg("武将碎片%s配置文件初始化失败！" % self._chip_no)
        self._config = chip_config

    @property
    def chip_no(self):
        return self._chip_no

    @property
    def num(self):
        return self._num

    @num.setter
    def num(self, value):
        self._num = value

    def consume(self, num):
        self.num-=num