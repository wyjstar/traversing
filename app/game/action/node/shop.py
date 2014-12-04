# -*- coding:utf-8 -*-
"""
created by server on 14-7-9下午2:39.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from shared.db_opear.configs_data.game_configs import shop_config
from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import is_consume
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return


@remoteserviceHandle('gate')
def lucky_draw_hero_501(pro_data, player):
    """抽取hero"""
    return shop_oper(pro_data, player)


@remoteserviceHandle('gate')
def lucky_draw_equipment_502(pro_data, player):
    """抽取equipment"""
    return shop_equipment_oper(pro_data, player)


@remoteserviceHandle('gate')
def buy_item_503(pro_data, player):
    """购买item"""
    return shop_oper(pro_data, player)


@remoteserviceHandle('gate')
def buy_gift_pack_504(pro_data, player):
    """购买礼包"""
    return shop_oper(pro_data, player)


@remoteserviceHandle('gate')
def get_shop_items_505(pro_data, player):
    """获取商品列表"""
    pass


def shop_oper(pro_data, player):
    """商城所有操作"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()

    shop_id = request.id
    shop_item = shop_config.get(shop_id)

    if is_consume(player, shop_item):
        # 判断是否消耗
        result = is_afford(player, shop_item.consume)  # 校验
        if not result.get('result'):
            response.res.result = False
            response.res.result_no = result.get('result_no')
            response.res.message = u'消费不足！'
        return_data = consume(player, shop_item.consume)  # 消耗
        get_return(player, return_data, response.consume)
    return_data = gain(player, shop_item.gain)  # 获取
    extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

    get_return(player, return_data, response.gain)
    get_return(player, extra_return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


def shop_equipment_oper(pro_data, player):
    """装备抽取"""
    request = ShopRequest()
    request.ParseFromString(pro_data)
    response = ShopResponse()

    shop_id = request.id
    shop_num = request.num
    shop_item = shop_config.get(shop_id)

    if shop_num == 1 and not is_consume(player, shop_item):
        # 免费抽取
        return_data = gain(player, shop_item.gain)  # 获取
        extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

        get_return(player, return_data, response.gain)
        get_return(player, extra_return_data, response.gain)
    # 多装备抽取
    elif shop_num >= 1:
        for i in range(shop_num):
            result = is_afford(player, shop_item.consume)  # 校验
            if not result.get('result'):
                response.res.result = False
                response.res.result_no = 101
                return response.SerializePartialToString()

        for i in range(shop_num):
            return_data = consume(player, shop_item.consume)  # 消耗
            get_return(player, return_data, response.consume)

        for i in range(shop_num):
            return_data = gain(player, shop_item.gain)  # 获取
            extra_return_data = gain(player, shop_item.extraGain)  # 额外获取

            get_return(player, return_data, response.gain)
            get_return(player, extra_return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()
