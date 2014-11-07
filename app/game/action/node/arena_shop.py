# -*- coding:utf-8 -*-
"""
created by server on 14-7-15下午8:33.
"""

from app.game.logic import arena_shop
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def arene_shop_1510(dynamic_id, pro_data):
    """武魂商店"""
    return arena_shop.arena_shop(dynamic_id, pro_data)


@remoteserviceHandle('gate')
def refresh_shop_items_1511(dynamic_id, pro_data=None):
    """刷新商品列表"""
    return arena_shop.refresh_shop_items(dynamic_id)


@remoteserviceHandle('gate')
def get_shop_items_1512(dynamic_id, pro_data=None):
    """获取商品列表"""
    return arena_shop.get_shop_items(dynamic_id)
