# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-27下午2:05.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.hero import *


@remote_service_handle
def get_heros_101(dynamic_id, pro_data=None):
    """取得武将列表
    """
    return get_heros(dynamic_id)


@remote_service_handle
def hero_upgrade_with_item_103(dynamicid, data):
    """武将升级，使用经验药水"""
    return hero_upgrade_with_item(dynamicid, data)


@remote_service_handle
def hero_break_104(dynamicid, data):
    """武将突破"""
    return hero_break(dynamicid, data)


@remote_service_handle
def hero_sacrifice_105(dynamicid, data):
    """武将献祭"""
    return hero_sacrifice(dynamicid, data)


@remote_service_handle
def hero_compose_106(dynamicid, data):
    """武将合成"""
    return hero_compose(dynamicid, data)















