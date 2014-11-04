# -*- coding:utf-8 -*-
"""
created by server on 14-7-16下午3:25.
"""
from app.game.logic.common.check import have_player
from app.proto_file.shop_pb2 import ShopRequest, ShopResponse
from app.proto_file.common_pb2 import CommonResponse
from shared.db_opear.configs_data.game_configs import shop_config
from app.game.logic.item_group_helper import is_afford
from app.game.logic.item_group_helper import consume
from app.game.logic.item_group_helper import gain
from app.game.logic.item_group_helper import get_return
import time


@have_player
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


@have_player
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


def is_consume(player, shop_item):
    """判断是否免费抽取"""
    free_period = shop_item.freePeriod
    shop_item_type = shop_item.type
    if free_period == -1:
        return True

    last_pick_time = 0
    if shop_item_type == 1 and free_period > 0:
        # 单抽良将
        last_pick_time = player.last_pick_time.fine_hero
    elif shop_item_type == 5 and free_period > 0:
        # 单抽神将
        last_pick_time = player.last_pick_time.excellent_hero
    elif shop_item_type == 2:
        # 单抽良装
        last_pick_time = player.last_pick_time.fine_equipment
    elif shop_item_type == 6:
        # 单抽神装
        last_pick_time = player.last_pick_time.excellent_equipment

    if last_pick_time + free_period*60*60 <= int(time.time()):
        # 抽取后重置时间
        if shop_item_type == 1:
            # 单抽良将
            player.last_pick_time.fine_hero = int(time.time())
        elif shop_item_type == 5:
            # 单抽神将
            player.last_pick_time.excellent_hero = int(time.time())
        elif shop_item_type == 2:
            # 单抽良装
            player.last_pick_time.fine_equipment = int(time.time())
        elif shop_item_type == 6:
            # 单抽神装
            player.last_pick_time.excellent_equipment = int(time.time())

        player.last_pick_time.save_data()
        return False

    return True
