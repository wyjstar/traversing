# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午6:54.
"""
from app.game.component.Component import Component


class CharacterFightCacheComponent(Component):
    """战斗缓存组件
    """
    def __init__(self, owner):
        super(self, CharacterFightCacheComponent).__init__(owner)

        self._stage_id = 0  # 关卡ID
        self._drop_num = 0  # 关卡小怪掉落数量



