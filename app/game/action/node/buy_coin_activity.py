# -*- coding:utf-8 -*-
"""
招财进宝
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import buy_coin_activity_pb2
from shared.db_opear.configs_data import game_configs
#from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const
from gfirefly.server.logobj import logger
from shared.utils.date_util import days_to_current, get_current_timestamp
from shared.tlog import tlog_action

@remoteserviceHandle('gate')
def get_buy_coin_activity_1407(data, player):
    """招财进宝初始化信息
    request: 无
    respone: GetBuyCoinInfoResponse
    """
    response = buy_coin_activity_pb2.GetBuyCoinInfoResponse()
    if days_to_current(player.buy_coin.last_time) > 0:
        player.buy_coin.buy_times = 0
        player.buy_coin.save_data()
    print("buy_times", player.buy_coin.buy_times)
    response.buy_times = player.buy_coin.buy_times
    item_no = 63002
    item = player.item_package.get_item(item_no)
    if not item:
        response.extra_can_buy_times = 0
    else:
        response.extra_can_buy_times = item.num
    return response.SerializePartialToString()

@remoteserviceHandle('gate')
def buy_coin_activity_1406(data, player):
    """招财进宝
    request: 无
    respone: BuyCoinResponse
    """
    response = buy_coin_activity_pb2.BuyCoinResponse()

    all_buy_times = player.buy_coin.buy_times # 购买次数
    buy_times = all_buy_times
    #extra_can_buy_times = player.buy_coin.extra_can_buy_times
    need_gold = 0
    gain_info = game_configs.base_config.get("getMoneyValue")
    free_times = game_configs.base_config.get("getMoneyFreeTimes")
    buy_times_price = game_configs.base_config.get("getMoneyBuyTimesPrice")

    # 获取 need_gold
    act_confs = game_configs.activity_config.get(26, [])
    xs = 1
    for act_conf in act_confs:
        if player.act.is_activiy_open(act_conf.id):
            xs = act_conf.parameterB
            free_times += act_conf.parameterA
            if act_conf.parameterC[0] <= buy_times:
                xs = 1

            break
    for k in sorted(buy_times_price.keys(), reverse=True):
        if buy_times >= k:
            need_gold = buy_times_price[k]
            break

    if free_times > buy_times:
        need_gold = 0
    logger.debug("need_gold %s, free_times %s, all_buy_times %s, xs %s" % (need_gold, free_times, all_buy_times, xs))

    if need_gold > player.finance.gold:
        logger.error("buy_coin_activity_1406: gold not enough %s, %s" % (need_gold, player.finance.gold))
        response.res.result = False
        response.res.result_no = 201
        return response.SerializePartialToString()

    item_no = 63002
    item = player.item_package.get_item(item_no)
    item_num = 0
    if item:
        item_num = item.num
    if player.base_info.buy_coin_times + free_times <= buy_times and item_num == 0:
        logger.error("buy_coin_activity_1406: times not enough %s, %s, %s" % (item_num, player.base_info.buy_coin_times, player.buy_coin.buy_times))
        response.res.result = False
        response.res.result_no = 1406
        return response.SerializePartialToString()

    coin_nums = 0  # 银币数量
    for k in sorted(gain_info.keys(), reverse=True):
        if buy_times >= k:
            coin_nums = gain_info[k]
            break

    def func():
        if player.base_info.buy_coin_times + free_times <= buy_times:
            # 使用招财令
            player.item_package.consume_item(item_no, 1)
        player.buy_coin.buy_times = all_buy_times + 1
        player.buy_coin.last_time = get_current_timestamp()
        player.buy_coin.save_data()
        add_coin_nums = coin_nums * xs

        player.finance.add_coin(int(add_coin_nums), const.BUY_COIN_ACT)
        player.finance.save_data()
        tlog_action.log('BuyCoin', player, need_gold,
                        player.buy_coin.buy_times,
                        int(add_coin_nums))

    res = player.pay.pay(need_gold, const.BUY_COIN_ACT, func)
    response.res.result = res
    if not res:
        response.res.result_no = 100
    return response.SerializeToString()
