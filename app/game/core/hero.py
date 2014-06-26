# -*- coding:utf-8 -*-
"""
created by server on 14-6-25下午5:27.
"""
from app.game.component.baseInfo.hero_base_info_component import HeroBaseInfoComponent


class Hero(object):
    """武将类"""

    def __init__(self, hero_id, hero_name):
        self._base_info = HeroBaseInfoComponent(self, hero_id, hero_name)





