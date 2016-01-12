# -*- coding:utf-8 -*-
"""
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import activity_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.utils.const import const
from shared.db_opear.configs_data.data_helper import parse
from shared.db_opear.configs_data.common_item import CommonGroupItem
from app.game.core import item_group_helper

from app.game.core.item_group_helper import is_afford
from app.game.core.item_group_helper import consume
from app.game.core.item_group_helper import gain
from app.game.core.item_group_helper import get_return
from shared.tlog import tlog_action


@remoteserviceHandle('gate')
def get_act_gift_1832(data, player):
    args = activity_pb2.GetActGiftRequest()
    args.ParseFromString(data)
    act_id = args.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    act_conf = game_configs.activity_config.get(act_id)
    is_open = player.base_info.is_activiy_open(act_id)
    if not act_conf or not is_open:
        response.res.result_no = 800
        return response.SerializeToString()
    act_type = act_conf.type
    received_ids = player.act.received_ids.get(act_type)
    if received_ids and act_id in received_ids:
        response.res.result_no = 801
        return response.SerializeToString()
    if act_type == 20:  # 战力
        res = get_20_gift(player, act_conf, response)
        tlog_arg = player.line_up_component.combat_power
    elif act_type == 21:  # 通关关卡
        res = get_21_gift(player, act_conf, response)
        tlog_arg = player.stage_component.stage_progress
    if res:
        if received_ids:
            player.act.received_ids.get(act_type).append(act_id)
        else:
            player.act.received_ids[act_type] = [act_id]
        player.act.save_data()
        response.res.result = True
        tlog_action.log('Activity', player, act_id, tlog_arg)

    return response.SerializeToString()


def get_20_gift(player, act_conf, response):  # 战力
    # if act_conf.parameterA > player.line_up_component.combat_power:
    if act_conf.parameterA > player.line_up_component.hight_power:
        response.res.result_no = 802
        return 0
    gain_data = act_conf.reward
    return_data = gain(player, gain_data, const.ACT20)
    get_return(player, return_data, response.gain)
    return 1


def get_21_gift(player, act_conf, response):  # 通关关卡
    if player.stage_component.get_stage(act_conf.parameterA).state != 1:
        response.res.result_no = 800
        return 0
    gain_data = act_conf.reward
    return_data = gain(player, gain_data, const.ACT21)
    get_return(player, return_data, response.gain)
    return 1


@remoteserviceHandle('gate')
def get_act_info_1831(data, player):
    """get act info"""
    args = activity_pb2.GetActInfoRequese()
    args.ParseFromString(data)
    act_type = args.act_type
    response = activity_pb2.GetActInfoResponse()
    response.act_type = act_type

    act_confs = game_configs.activity_config.get(act_type, [])
    is_open = 0
    act_id = 0
    for act_conf in act_confs:
        if player.base_info.is_activiy_open(act_conf.id):
            is_open = 1
            act_id = act_conf.id
            break
    if not is_open:
        response.res.result = True
        response.res.result_no = 800
        return response.SerializeToString()

    received_ids = player.act.received_ids.get(act_type)
    if received_ids:
        for id in received_ids:
            response.received_act_ids.append(id)
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_activity_28_gift_1834(data, player):
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    quantity = request.quantity
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    activity_conf = game_configs.activity_config.get(activity_id)
    if not activity_conf:
        logger.error('not found activity id:%s', activity_id)
        response.res.result_no = 183401
        return response.SerializeToString()
    if not player.base_info.is_activiy_open(activity_id):
        logger.error('activity not open id:%s', activity_id)
        response.res.result_no = 183402
        return response.SerializeToString()

    price = activity_conf.parameterA * activity_conf.parameterC[0]
    activity_consume = parse({107: [price, price, 29]})
    for i in range(30):
        print player.finance[i]
    result = is_afford(player, activity_consume, multiple=quantity)
    if not result.get('result'):
        logger.error('activity not enough res:%s', price)
        response.res.result_no = 183403
        return response.SerializeToString()

    consume_data = consume(player,
                           activity_consume,
                           const.act_28,
                           multiple=quantity)
    get_return(player, consume_data, response.consume)

    return_data = gain(player,
                       activity_conf.reward,
                       const.act_28,
                       multiple=quantity)
    get_return(player, return_data, response.gain)
    tlog_action.log('GodHeroExchange', player, activity_id, quantity)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_fund_activity_1850(data, player):
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    act_item = game_configs.activity_config.get(activity_id)
    if act_item is None:
        logger.error('not found activity id:%s--%s', activity_id,
                     player.fund_activity.fund_info.keys())
        response.res.result_no = 185000
        return response.SerializeToString()

    if activity_id not in player.fund_activity.fund_info:
        logger.error('not found activity id:%s--%s', activity_id,
                     player.fund_activity.fund_info.keys())
        response.res.result_no = 185001
        return response.SerializeToString()

    fund = player.fund_activity.fund_info[activity_id]
    if fund['state'] != 1:
        logger.error('activity id:%s is draw', activity_id)
        response.res.result_no = 185003
        return response.SerializeToString()

    if len(fund['accumulate_days']) < int(act_item.parameterA):
        logger.error('activity accumulate days not enough:%s-%s',
                     int(act_item.parameterA), fund['accumulate_days'])
        response.res.result_no = 185004
        return response.SerializeToString()

    if act_item.parameterB > player.base_info.level:
        logger.error('activity level error:%s-%s',
                     act_item.parameterB, player.base_info.level)
        response.res.result_no = 185005
        return response.SerializeToString()

    if len(act_item.parameterC) == 1 and \
            act_item.parameterC[0] > player.line_up_component.hight_power:
        logger.error('activity ap error:%s-%s',
                     player.line_up_component.hight_power,
                     act_item.parameterC[0])
        response.res.result_no = 185005
        return response.SerializeToString()

    if len(act_item.parameterD) == 1 and \
       player.stage_component.get_stage(act_item.parameterD[0]).state != 1:
        logger.error('activity stage:%s is not open',
                     act_item.parameterD[0])
        response.res.result_no = 185005
        return response.SerializeToString()

    fund['state'] = 2
    player.fund_activity.save_data()
    return_data = gain(player,
                       act_item.reward,
                       const.act_28)
    get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def activate_fund_activity_1851(data, player):
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    act_item = game_configs.activity_config.get(activity_id)
    if act_item is None:
        logger.error('not found activity id:%s--%s', activity_id,
                     player.fund_activity.fund_info.keys())
        response.res.result_no = 185100
        return response.SerializeToString()

    if act_item.parameterB == 0:
        logger.error('no need activate this activity:%s', activity_id)
        response.res.result_no = 185101
        return response.SerializeToString()

    fund = player.fund_activity.precondition.get(activity_id)
    if fund is None:
        logger.error('activity:%s is not exist', activity_id)
        response.res.result_no = 185102
        return response.SerializeToString()

    need_gold = act_item.parameterB
    price = []
    price.append(CommonGroupItem(const.COIN, need_gold, need_gold, const.GOLD))

    def func():
        consume_return_data = item_group_helper.consume(player,
                                                        price,
                                                        const.MINE_ACC)
        item_group_helper.get_return(player,
                                     consume_return_data,
                                     response.consume)
    player.pay.pay(need_gold, const.FUND, func)

    fund['consume'] = need_gold
    player.fund_activity.check_precondition()
    player.fund_activity.check_time()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_fund_activity_info_1854(data, player):
    response = activity_pb2.GetFundActivityResponse()

    info = player.fund_activity.fund_info
    for k, v in info.items():
        act = response.info.add()
        act.act_id = k
        act.state = v['state']
        act.accumulate_days = len(v['accumulate_days'])

    info = player.fund_activity.precondition
    for k, v in info.items():
        act = response.info.add()
        act.act_id = k
        act.state = v.get('state', 0)
        act.recharge = v.get('recharge', 0)
        act.max_single_recharge = v.get('max_single_recharge', 0)

    print 'get_fund_activity_info_1854:', response
    return response.SerializeToString()
