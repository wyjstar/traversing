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
from app.game.core.activity import get_act_info


@remoteserviceHandle('gate')
def get_act_gift_1832(data, player):
    args = activity_pb2.GetActGiftRequest()
    args.ParseFromString(data)
    act_id = args.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    act_conf = game_configs.activity_config.get(act_id)
    is_open = player.act.is_activiy_open(act_id)
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
    if not player.act.is_activiy_open(activity_id):
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
    # 成长基金活动
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    if not player.act.is_activiy_open(activity_id):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    act_item = game_configs.activity_config.get(activity_id)
    if act_item is None:
        response.res.result_no = 185000
        return response.SerializeToString()

    info = get_act_info(player, activity_id)

    if info.get('state') != 2:
        response.res.result = False
        logger.error("条件不满足")
        response.res.result_no = 800
        return response.SerializeToString()

    return_data = gain(player,
                       act_item.reward,
                       const.FUND)
    get_return(player, return_data, response.gain)
    player.act.act_infos[activity_id][0] = 3
    player.act.save_data()

    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def activate_fund_activity_1851(data, player):
    # 成长基金活动
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    if not player.act.is_activiy_open(activity_id):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    act_item = game_configs.activity_config.get(activity_id)

    if act_item.parameterB == 0:
        logger.error('no need activate this activity:%s', activity_id)
        response.res.result_no = 185101
        return response.SerializeToString()

    info = get_act_info(player, activity_id)

    if info.get('state') != 2:
        response.res.result = False
        logger.error("条件不满足")
        response.res.result_no = 800
        return response.SerializeToString()

    need_gold = act_item.parameterB
    price = []
    price.append(CommonGroupItem(const.RESOURCE, need_gold, need_gold, const.GOLD))

    def func():
        consume_return_data = item_group_helper.consume(player,
                                                        price,
                                                        const.MINE_ACC)
        item_group_helper.get_return(player,
                                     consume_return_data,
                                     response.consume)
    player.pay.pay(need_gold, const.FUND, func)

    player.act.act_infos[activity_id][0] = 3
    player.act.update_51()
    player.act.save_data()

    # fund['consume'] = need_gold
    # player.fund_activity.check_precondition()
    # player.fund_activity.check_time()
    response.res.result = True
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_fund_activity_info_1854(data, player):
    # 成长基金活动
    response = activity_pb2.GetFundActivityResponse()

    for act_conf in game_configs.activity_config[51]:
        if not player.act.is_activiy_open(act_conf.id):
            continue
        act_info = get_act_info(player, act_conf.id)

        act = response.info.add()
        act.act_id = act_conf.id
        act.state = act_info.get('state')
        act.accumulate_days = len(act_info.get('jindu'))

    for act_conf in game_configs.activity_config[50]:
        if not player.act.is_activiy_open(act_conf.id):
            continue
        act_info = get_act_info(player, act_conf.id)

        act = response.info.add()
        act.act_id = act_conf.id
        act.state = act_info.get('state')
        act.recharge = act_info.get('jindu')[0]
        act.max_single_recharge = act_info.get('jindu')[1]

        # act.state = v.get('state', 0)
        # act.recharge = v.get('recharge', 0)
        # act.max_single_recharge = v.get('max_single_recharge', 0)

    print 'get_fund_activity_info_1854:', response
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_activity_info_1855(data, player):
    # 通用 获取活动信息
    args = activity_pb2.GetActivityInfoRequese()
    args.ParseFromString(data)
    select_type = args.select_type
    select_values = args.value
    response = activity_pb2.GetActivityInfoResponse()
    print select_type, select_values, '========================act type 1855'

    configs = []
    for select_value in select_values:
        if select_type == 1:
            configs = game_configs.activity_config.get(select_value, [])
        elif select_type == 2:
            configs = game_configs.activity_config.get('icon').get(select_value, [])
        else:
            response.res.result = False
            print 'select type error ========================act info 1855'
            response.res.result_no = 800
            return response.SerializeToString()
        if configs and configs[0].type == 18:
            # 连续登录
            player.act.update_act_with_get()
        for act_conf in configs:
            if act_conf.icon == 10179:  # 七日活动
                continue
            if not player.act.is_activiy_open(act_conf.id):
                continue
            act_info = get_act_info(player, act_conf.id)
            print act_info, '========================act info 1855'

            info_pro = response.info.add()
            info_pro.act_id = act_conf.id
            if act_conf.type == 51:
                info_pro.state = act_info.get('state')
                info_pro.accumulate_days = len(act_info.get('jindu'))
            elif act_conf.type == 50:
                info_pro.state = act_info.get('state')
                info_pro.recharge = act_info.get('jindu')[0]
                info_pro.max_single_recharge = act_info.get('jindu')[1]
            else:
                if act_info.get('state'):
                    info_pro.state = act_info.get('state')
                if act_info.get('state') == 1 and act_info.get('jindu'):
                    info_pro.jindu = act_info.get('jindu')

    player.act.save_data()
    response.res.result = True
    print 'get_activity_info_1855:', response
    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_activity_gift_1856(data, player):
    request = activity_pb2.GetActGiftRequest()
    request.ParseFromString(data)
    activity_id = request.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    if not player.act.is_activiy_open(activity_id):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    act_conf = game_configs.activity_config.get(activity_id)
    info = get_act_info(player, activity_id)

    if info.get('state') != 2:
        response.res.result = False
        logger.error("this start target 条件不满足")
        response.res.result_no = 800
        return response.SerializeToString()

    need_gold = 0
    need_gold_acts = [30, 50]

    if act_conf.type in need_gold_acts:
        need_gold = act_conf.parameterB
        if need_gold:
            price = parse({107: [need_gold, need_gold, 2]})
            if not is_afford(player, price):
                response.res.result = False
                response.res.result_no = 102
                return response.SerializeToString()

    def func():
        return_data = gain(player, act_conf.reward, const.ACTIVITY)  # 获取
        get_return(player, return_data, response.gain)
        if act_conf.type == 30:
            if act_conf.count <= (info.get('jindu') + 1):
                player.act.act_infos[activity_id][0] = 3
            else:
                player.act.act_infos[activity_id] = [1, info.get('jindu') + 1]
        else:
            player.act.act_infos[activity_id][0] = 3

    player.pay.pay(need_gold, const.ACTIVITY, func)
    player.act.save_data()

    response.res.result = True
    return response.SerializeToString()
