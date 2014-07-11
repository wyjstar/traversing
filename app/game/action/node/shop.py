# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.shop_pb2 import ShopRequest
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import shop_config
from app.game.core.PlayersManager import PlayersManager
from app.game.logic.item_group_helper import is_afford, consume, gain


def lucky_draw_hero_501(dynamic_id, pro_data):
    """抽取hero"""
    return shop_oper(dynamic_id, pro_data)


def lucky_draw_equipment_502(dynamic_id, pro_data):
    """抽取equipment"""
    return shop_oper(dynamic_id, pro_data)


def buy_item_503(dynamic_id, pro_data):
    """购买item"""
    return shop_oper(dynamic_id, pro_data)


def buy_gift_pack_504(dynamic_id, pro_data):
    """购买礼包"""
    return shop_oper(dynamic_id, pro_data)


def shop_oper(dynamic_id, pro_data):
    """商城所有操作"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = CommonResponse()

    shop_id = request.id
    player = PlayersManager().get_player_by_dynamic_id(dynamic_id)
    shop_item = shop_config.get(shop_id)
    result = is_afford(player, shop_item.consume)  # 校验
    if not result.get('result'):
        response.result = False
        response.message = '消费不足！'
    consume(player, shop_item.consume)  # 消耗
    gain(player, shop_item.gain)  # 获取
    gain(player, shop_item.extra_gain)  # 额外获取

    response.result = True
    return response.SerializeToString()