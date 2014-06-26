# -*- coding:utf-8 -*-
"""
created by server on 14-6-26上午11:47.
"""
from app.game.component.baseInfo.BaseInfoComponent import BaseInfoComponent


class HeroBaseInfoComponent(BaseInfoComponent):
    """武将基础信息"""
    def __init__(self, owner, hero_id, hero_name):
        super(HeroBaseInfoComponent, self).__init__(owner, hero_id, hero_name)

