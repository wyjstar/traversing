# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午8:33.
"""

from app.game.logic.soul_shop import soul_shop, get_shop_items, refresh_shop_items
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def soul_shop_506(dynamic_id, pro_data):
    """武魂商店"""
    return soul_shop(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def refresh_shop_items_507(dynamic_id, pro_data=None):
    """刷新商品列表"""
    return refresh_shop_items(dynamic_id)

@remoteserviceHandle('gate')
def get_shop_items_508(dynamic_id, pro_data=None):
    """获取商品列表"""
    return get_shop_items(dynamic_id)


