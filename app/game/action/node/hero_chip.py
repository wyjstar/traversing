# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:07.
"""
from app.game.logic.hero_chip import get_hero_chips
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def get_hero_chips_108(dynamic_id, pro_data=None):
    """取得武将碎片列表
    """
    return get_hero_chips(dynamic_id)
