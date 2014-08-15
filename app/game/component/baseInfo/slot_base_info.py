# -*- coding:utf-8 -*-
"""
created by server on 14-8-13下午3:20.
"""
from app.game.component.baseInfo.BaseInfoComponent import BaseInfoComponent


class SlotBaseInfoComponent(BaseInfoComponent):
    """格子基础信息组件
    """

    def __init__(self, owner, bid, base_name, activation):
        super(SlotBaseInfoComponent, self).__init__(owner, bid, base_name)

        self._activation = activation  # 激活状态 0：未激活  1：激活

    @property
    def activation(self):
        return self._activation

    @activation.setter
    def activation(self, activation):
        self._activation = activation