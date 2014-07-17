# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午4:58.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.equipment_chip import *


@remote_service_handle
def get_equipment_chips_407(dynamic_id, pro_data=None):
    """取得武将碎片列表
    """
    return get_equipment_chips(dynamic_id)