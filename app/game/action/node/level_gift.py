# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic import level_gift


@remote_service_handle
def get_level_gift_1131(dynamic_id, data):
    """get online gift"""
    return level_gift.get_level_gift(dynamic_id, data)
