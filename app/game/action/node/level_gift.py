# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""

from app.game.logic import level_gift
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def get_level_gift_1131(dynamic_id, data):
    """get online gift"""
    return level_gift.get_level_gift(dynamic_id, data)
