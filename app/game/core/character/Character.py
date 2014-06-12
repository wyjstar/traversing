# -*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""
from app.game.component.baseInfo.CharacterBaseInfoComponent import CharacterBaseInfoComponent


class Character(object):
    """角色通用类
    """

    def __init__(self, cid, name):
        """创建一个角色
        """
        self._base_info = CharacterBaseInfoComponent(self, cid, name)
        self._character_type = 0  # 角色的类型  1:玩家角色 2:怪物 3:宠物

    @property
    def base_info(self):
        return self._base_info

    @property
    def character_type(self):
        """获取角色类型
        """
        return self._character_type

    @character_type.setter
    def character_type(self, character_type):
        """设置角色类型
        """
        self._character_type = character_type