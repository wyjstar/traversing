# -*- coding:utf-8 -*-
"""
招财进宝
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import buy_coin_activity_pb2
from shared.db_opear.configs_data import game_configs
#from app.game.core.item_group_helper import gain, get_return
#from shared.utils.const import const
from gfirefly.server.logobj import logger

@remoteserviceHandle('gate')
def get_buy_coin_activity_1407(data, player):
    """招财进宝初始化信息
    request: 无
    respone: GetBuyCoinInfoResponse
    """
    response = buy_coin_activity_pb2.GetBuyCoinInfoResponse()
    response.buy_times = player.buy_coin.buy_times
    response.extra_can_buy_times = player.buy_coin.extra_can_buy_times
    logger.debug("get_buy_coin_activity_1407: %s %s" % (player.buy_coin.buy_times, player.buy_coin.extra_can_buy_times))
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def buy_coin_activity_1406(data, player):
    """招财进宝
    request: 无
    respone: BuyCoinResponse
    """
    response = buy_coin_activity_pb2.BuyCoinResponse()

    buy_times = player.buy_coin.buy_times # 购买次数
    extra_can_buy_times = player.buy_coin.extra_can_buy_times
    need_gold = 0
    gain_info = game_configs.base_config.get("getMoneyValue")
    free_times = game_configs.base_config.get("getMoneyFreeTimes")
    buy_times_price = game_configs.base_config.get("getMoneyBuyTimesPrice")

    # 获取 need_gold
    for k in sorted(buy_times_price.keys()):
        if buy_times - free_times <= k:
            need_gold = buy_times_price[k]
            break

    if free_times > buy_times:
        need_gold = 0

    if need_gold > player.finance.gold:
        logger.error("buy_coin_activity_1406: gold not enough %s, %s" % (need_gold, player.finance.gold))
        response.res = False
        response.result_no = 101
        return response.SerializePartialToString()

    if extra_can_buy_times + player.base_info.buy_coin_times <= buy_times:
        logger.error("buy_coin_activity_1406: times not enough %s, %s, %s" % (extra_can_buy_times, player.base_info.buy_coin_times, player.buy_times))
        response.res = False
        response.result_no = 1406
        return response.SerializePartialToString()

    coin_nums = 0 # 银币数量
    for k in sorted(gain_info.keys()):
        if buy_times - free_times <= k:
            coin_nums = gain_info[k]
            break
    def func():
        player.buy_coin.buy_times = buy_times + 1
        player.finance.add_coin(coin_nums)
        player.finance.save_data()

    player.pay.pay(need_gold, func)
    response.res.result = True
    logger.debug("response %s", response)
    return response.SerializeToString()
