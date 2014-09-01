# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic import online_gift


@remote_service_handle
def get_online_gift_1121(dynamic_id, data):
    """get online gift"""
    return online_gift.get_online_gift(dynamic_id, data)
