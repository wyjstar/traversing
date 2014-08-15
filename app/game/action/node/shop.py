# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.shop import shop_oper, shop_equipment_oper


@remote_service_handle
def lucky_draw_hero_501(dynamic_id, pro_data):
    """抽取hero"""
    return shop_oper(dynamic_id, pro_data)


@remote_service_handle
def lucky_draw_equipment_502(dynamic_id, pro_data):
    """抽取equipment"""
    return shop_equipment_oper(dynamic_id, pro_data)


@remote_service_handle
def buy_item_503(dynamic_id, pro_data):
    """购买item"""
    return shop_oper(dynamic_id, pro_data)


@remote_service_handle
def buy_gift_pack_504(dynamic_id, pro_data):
    """购买礼包"""
    return shop_oper(dynamic_id, pro_data)


@remote_service_handle
def get_shop_items_505(dynamic_id, pro_data):
    """获取商品列表"""
    pass
