# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.shop_pb2 import ShopRequest, CommonResponse


def lucky_draw_hero_501(dynamic_id, pro_data):
    """抽取hero"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    shop_id = request.id

    response = CommonResponse()
    response.result = True
    return response.SerializeToString()


def lucky_draw_equipment_502(dynamic_id, pro_data):
    """抽取equipment"""
    pass


def buy_item_503(dynamic_id, pro_data):
    """购买item"""
    pass


def buy_gift_pack_504(dynamic_id, pro_data):
    """购买礼包"""
    pass