#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""


class Component(object):
    """
    抽象的组件对象
    """
    def __init__(self, owner):
        """
        创建一个组件
        @param owne: owner of this component
        """
        self._owner = owner

    @property
    def owner(self):
        return self._owner