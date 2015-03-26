# -*- coding:utf-8 -*-
"""
签到
created by server on 14-8-25下午8:29.
"""
from app.proto_file.sign_in_pb2 import RepairSignInRequest
from app.proto_file.sign_in_pb2 import ContinuousSignInRequest
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from app.proto_file.sign_in_pb2 import SignInResponse
from app.proto_file.sign_in_pb2 import ContinuousSignInResponse
from app.proto_file.sign_in_pb2 import GetSignInResponse
from app.game.core.drop_bag import BigBag
from shared.utils.const import const
from shared.utils.xtime import timestamp_to_date
from gfirefly.server.logobj import logger


@remoteserviceHandle('gate')
def get_sign_in_1400(pro_data, player):
    """获取签到初始化信息"""
    response = GetSignInResponse()
    sign_in_component = player.sign_in_component
    sign_in_component.clear_sign_days()
    [response.days.append(i) for i in sign_in_component.sign_in_days]
    response.sign_round = sign_in_component.sign_round
    response.current_day = sign_in_component.current_day()
    [response.continuous_sign_in_prize.append(i) for i in sign_in_component.continuous_sign_in_prize]
    response.repair_sign_in_times = sign_in_component.repair_sign_in_times
    logger.debug("get_sign_in: days %s  sign_round %s current_day %s" %  (sign_in_component.sign_in_days, sign_in_component.sign_round, response.current_day))
    logger.debug("get_sign_in: %s" % response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def sign_in_1401(pro_data, player):
    """签到"""
    print "sign_in++++++++++++++"
    response = SignInResponse()

    # 签到
    day = player.sign_in_component.current_day()

    register_time = player.base_info.register_time
    register_time = timestamp_to_date(register_time)

    # 同一天签到校验
    if player.sign_in_component.is_signd(day):
        print "sign in error code:", 1405
        response.res.result = False
        response.res.result_no = 1405
        return response.SerializePartialToString()

    player.sign_in_component.sign_in(day)
    player.sign_in_component.save_data()

    sign_round = player.sign_in_component.sign_round
    # 获取奖励
    if not game_configs.sign_in_config.get(sign_round) or not game_configs.sign_in_config.get(sign_round).get(day):
        return
    sign_in_info = game_configs.sign_in_config.get(sign_round).get(day)
    return_data = gain(player, sign_in_info.get("reward"), const.SIGN_GIFT)
    get_return(player, return_data, response.gain)
    #vip双倍
    if player.base_info.vip_level >= sign_in_info.get("vipDouble"):
        get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def continus_sign_in_1402(pro_data, player):
    """累积签到"""
    request = ContinuousSignInRequest()
    request.ParseFromString(pro_data)
    days = request.sign_in_days
    response = ContinuousSignInResponse()

    # 验证连续签到日期
    if len(player.sign_in_component.sign_in_days) < days:
        response.res.result = False
        response.res.result_no = 1402
        return response.SerializePartialToString()
    if days in player.sign_in_component.continuous_sign_in_prize:
        response.res.result = False
        response.res.result_no = 1403
        return response.SerializePartialToString()

    player.sign_in_component.continuous_sign_in_prize.append(days)
    player.sign_in_component.save_data()

    reward = player.sign_in_component.get_sign_in_reward(days)
    if not reward:
        response.res.result = False
        response.res.result_no = 1404
        return response.SerializePartialToString()
    return_data = gain(player, reward, const.CONTINUS_SIGN)
    get_return(player, return_data, response.gain)

    response.res.result = True
    logger.debug(response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def repair_sign_in_1403(pro_data, player):
    """补充签到"""
    request = RepairSignInRequest()
    request.ParseFromString(pro_data)
    day = request.day
    print "repair_sign_in+++++++++++", day
    response = SignInResponse()

    sign_in_add = game_configs.base_config.get("signInAdd")
    if not sign_in_add:
        return

    repair_sign_in_times = player.sign_in_component.repair_sign_in_times
    gold = player.finance.gold
    logger.debug("repair sign in : %s %s" % (repair_sign_in_times, len(sign_in_add)))
    # 校验签到次数
    if repair_sign_in_times >= len(sign_in_add):
        logger.debug("repair sigin in max")
        response.res.result = False
        response.res.result_no = 1404
        return response.SerializePartialToString()
    # 校验消耗元宝数
    consume_gold = sign_in_add[repair_sign_in_times]
    if consume_gold > gold:
        response.res.result = False
        response.res.result_no = 102
        return response.SerializePartialToString()

    # 消耗
    player.finance.consume_gold(consume_gold)
    player.finance.save_data()
    # 签到奖励

    # 同一天签到校验
    if player.sign_in_component.is_signd(day):
        response.res.result = False
        response.res.result_no = 1405
        return response.SerializePartialToString()

    player.sign_in_component.sign_in(day)
    player.sign_in_component.save_data()
    sign_round = player.sign_in_component.sign_round
    if not game_configs.sign_in_config.get(sign_round) or not game_configs.sign_in_config.get(sign_round).get(day):
        return
    gain_data = game_configs.sign_in_config.get(sign_round).get(day)
    return_data = gain(player, gain_data, const.REPAIR_SIGN)
    get_return(player, return_data, response.gain)

    player.sign_in_component.repair_sign_in_times += 1
    player.sign_in_component.save_data()
    response.res.result = True
    return response.SerializePartialToString()
