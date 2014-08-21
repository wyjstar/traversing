# -*- coding:utf-8 -*-
"""
created by server on 14-7-3下午4:16.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.item import get_items, use_item


@remote_service_handle
def get_items_301(dynamic_id, pro_data=None):
    """取得全部道具
    """
    print "301+++++++++++++++++++"
    return get_items(dynamic_id)


@remote_service_handle
def use_item_302(dynamic_id, pro_data):
    """使用道具"""
    return use_item(dynamic_id, pro_data)














