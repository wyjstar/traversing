# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午8:06.
"""
from shared.db_opear.configs_data.game_configs import hero_chip_config
from gtwisted.utils import log


class HeroChip(object):
    """武将碎片"""
    def __init__(self, no, num):
        self._chip_no = no  # 碎片编号
        self._num = num  # 碎片数量
        chip_config = hero_chip_config.get(self._chip_no)
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

    def consume_chip(self, num):
        """消费碎片"""
        self.num -= num


