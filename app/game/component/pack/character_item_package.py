# -*- coding:utf-8 -*-
"""
created by server on 14-7-2下午4:51.
"""
from app.game.component.Component import Component


class CharacterItemPackageComponent(Component):
    """角色的道具包裹组件
    """
    def __init__(self, owner):
        super(CharacterItemPackageComponent, self).__init__(owner)
        self._items = {}  # 背包道具 {'item_no': num}