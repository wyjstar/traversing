#-*- coding:utf-8 -*-
"""
created by server on 14-5-27下午5:21.
"""

from app.game.component.baseInfo.BaseInfoComponent import BaseInfoComponent


class CharacterBaseInfoComponent(BaseInfoComponent):
    """玩家基础信息组件类
    """
    def __init__(self, owner, cid, nickname=u"", vip_type=1):
        """
        Constructor
        """
        BaseInfoComponent.__init__(self, owner, cid, nickname)
        self._vip_type = vip_type  # 玩家类型
        
    @property
    def vip_type(self):
        return self._vip_type

    @vip_type.setter
    def vip_type(self, vip_type):
        self._vip_type = vip_type
