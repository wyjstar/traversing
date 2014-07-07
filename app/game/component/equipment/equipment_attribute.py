# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午4:29.
"""
from app.game.component.Component import Component


class EquipmentAttributeComponent(Component):
    """装备属性
    """

    def __init__(self, owner, strengthen_lv, awakening_lv):
        super(EquipmentAttributeComponent, self).__init__(owner)

        self._strengthen_lv = strengthen_lv  # 强化等级
        self._awakening_lv = awakening_lv  # 觉醒等级

    @property
    def strengthen_lv(self):
        return self._strengthen_lv

    @property
    def awakening_lv(self):
        return self._awakening_lv


