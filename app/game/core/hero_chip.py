# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午8:06.
"""
from shared.db_opear.configs_data.game_configs import all_config_name
from gtwisted.utils import log


class HeroChip(object):
    """武将碎片"""
    def __init__(self, mmode=None):
        """
        :param mmode: 对应reidis中的一行数据
        """
        self._chip_no = 0  # 碎片编号
        self._num = 0  # 碎片数量
        self._mmode = mmode
        chip_config = all_config_name['hero_chip_config'].get(self._chip_no)
        if not chip_config:
            log.msg("武将碎片%s配置文件初始化失败！" % self._chip_no)
        self._config = chip_config

    def init_data(self):
        if not self._mmode:
            log.msg("武将碎片初始化失败！")
        self._chip_no = self._mmode.get('hero_chip_no')
        self._num = self._mmode.get('num')

    @property
    def chip_no(self):
        return self._chip_no

    @property
    def num(self):
        return self._num

    @num.setter
    def num(self, value):
        self._num = value
        self._mmode.update('num', self._num)

    def consume(self, num):
        """消费碎片"""
        self.num -= num
        self._mmode.update('num', self._num)