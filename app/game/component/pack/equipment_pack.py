# -*- coding:utf-8 -*-
"""
created by server on 14-7-7下午5:21.
"""
from app.game.component.Component import Component


class EquipmentPackComponent(Component):
    """装备背包属性
    """
    def __init__(self, owner):
        super(EquipmentPackComponent, self).__init__(owner)

        self._is_strengthen = True  # 是否可以升级
        self._is_awakening = True  # 是否可以觉醒