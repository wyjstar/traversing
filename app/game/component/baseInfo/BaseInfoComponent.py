# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午4:58.
"""
from app.game.component.Component import Component


class BaseInfoComponent(Component):
    """
    抽象的基本信息对象
    """

    def __init__(self, owner, bid, base_name):
        """
        创建基本信息对象
        @param id: owner的id
        @param name: 基本名称
        """
        Component.__init__(self, owner)
        self._id = bid                   # owner的id
        self._base_name = base_name       # 基本名字

    @property
    def id(self):
        return self._id

    @id.setter
    def id(self, bid):
        self._id = bid

    @property
    def base_name(self):
        return self._base_name

    @base_name.setter
    def base_name(self, base_name):
        self._base_name = base_name