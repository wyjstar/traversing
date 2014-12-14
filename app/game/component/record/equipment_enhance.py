# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午9:53.
"""
from app.game.component.Component import Component


class EquipmentEnhanceComponent(Component):
    """装备
    """

    def __init__(self, owner, enhance_record):
        super(EquipmentEnhanceComponent, self).__init__(owner)
        self._enhance_record = enhance_record

    @property
    def enhance_record(self):
        return self._enhance_record

    @enhance_record.setter
    def enhance_record(self, value):
        self._enhance_record = value
