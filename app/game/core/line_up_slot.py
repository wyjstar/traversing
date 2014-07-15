# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""


class LineUpSlot(object):
    """卡牌位"""
    def __init__(self, hero_no, equipment_ids=['']*6):
        self._hero_no = hero_no
        self._equipment_ids = equipment_ids

    @property
    def hero_no(self):
        return self._hero_no

    @hero_no.setter
    def hero_no(self, value):
        self._hero_no = value

    @property
    def equipment_ids(self):
        return self._equipment_ids

    @equipment_ids.setter
    def equipment_ids(self, value):
        self._equipment_ids = value































