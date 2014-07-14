# -*- coding:utf-8 -*-
"""
created by server on 14-7-5下午3:25.
"""


class LineUpItem(object):
    """卡牌位"""
    def __init__(self, hero_no, equipment_ids=[0]*6, is_active=True):
        self._hero_no = hero_no
        self._equipment_ids = equipment_ids
        self._is_active = is_active

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

    @property
    def is_active(self):
        return self._is_active

    @is_active.setter
    def is_active(self, value):
        self._is_active = value































