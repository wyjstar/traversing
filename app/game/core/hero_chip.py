# -*- coding:utf-8 -*-
"""
created by server on 14-6-27下午8:06.
"""

class HeroChip(object):
    """武将碎片"""
    def __init__(self, no, num):
        self._chip_no = no  # 碎片编号
        self._num = num  # 碎片数量

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

    def update_pb(self, hero_chip_pb):
        hero_chip_pb.hero_chip_no = self._chip_no
        hero_chip_pb.hero_chip_num = self._num
