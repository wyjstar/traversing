# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

from app.game.logic import online_gift
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def get_online_gift_1121(dynamic_id, data):
    """get online gift"""
    return online_gift.get_online_gift(dynamic_id, data)


@remoteserviceHandle('gate')
def get_online_and_level_gift_data_1120(dynamic_id, data):
    return online_gift.get_online_and_level_gift_data(dynamic_id, data)
