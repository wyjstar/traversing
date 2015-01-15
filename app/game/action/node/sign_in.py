# -*- coding:utf-8 -*-
"""
签到
created by server on 14-8-25下午8:29.
"""
from app.proto_file.sign_in_pb2 import RepairSignInRequest
from app.proto_file.sign_in_pb2 import ContinuousSignInRequest
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data.game_configs import sign_in_config
from shared.db_opear.configs_data.game_configs import base_config
from app.game.core.item_group_helper import gain, get_return
from app.proto_file.sign_in_pb2 import SignInResponse
from app.proto_file.sign_in_pb2 import ContinuousSignInResponse
from app.proto_file.sign_in_pb2 import GetSignInResponse
from app.game.core.drop_bag import BigBag
import datetime
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_sign_in_1400(pro_data, player):
    """获取签到初始化信息"""
    response = GetSignInResponse()
    sign_in_component = player.sign_in_component
    [response.days.append(i) for i in sign_in_component.sign_in_days]
    response.continuous_sign_in_days = sign_in_component.continuous_sign_in_days
    [response.continuous_sign_in_prize.append(i) for i in sign_in_component.continuous_sign_in_prize]
    response.repair_sign_in_times = sign_in_component.repair_sign_in_times
    print "get_sign_in:", player.sign_in_component.sign_in_days, player.base_info.id
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def sign_in_1401(pro_data, player):
    """签到"""
    print "sign_in++++++++++++++"
    response = SignInResponse()

    # 签到
    date = datetime.datetime.now()
    month = date.month
    day = date.day

    # 同一天签到校验
    if player.sign_in_component.is_signd(month, day):
        print "sign in error code:", 1405
        response.res.result = False
        response.res.result_no = 1405
        return response.SerializePartialToString()

    player.sign_in_component.sign_in(month, day)
    player.sign_in_component.save_data()

    # 获取奖励
    if not sign_in_config.get(month) or not sign_in_config.get(month).get(day):
        return
    gain_data = sign_in_config.get(month).get(day)
    return_data = gain(player, gain_data, const.SIGN_GIFT)
    get_return(player, return_data, response.gain)
    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def continus_sign_in_1402(pro_data, player):
    """连续签到"""
    request = ContinuousSignInRequest()
    request.ParseFromString(pro_data)
    days = request.sign_in_days
    response = ContinuousSignInResponse()

    sign_in_prize = base_config.get("signInPrize")
    if not sign_in_prize:
        return
    # 验证连续签到日期
    if player.sign_in_component.continuous_sign_in_days < days:
        response.res.result = False
        response.res.result_no = 1402
        return response.SerializePartialToString()
    if days in player.sign_in_component.continuous_sign_in_prize:
        response.res.result = False
        response.res.result_no = 1403
        return response.SerializePartialToString()

    player.sign_in_component.continuous_sign_in_prize.append(days)
    player.sign_in_component.save_data()

    drop_bag_id = sign_in_prize.get(days)
    big_bag = BigBag(drop_bag_id)
    gain_data = big_bag.get_drop_items()
    return_data = gain(player, gain_data, const.CONTINUS_SIGN)
    get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def repair_sign_in_1403(pro_data, player):
    """补充签到"""
    request = RepairSignInRequest()
    request.ParseFromString(pro_data)
    day = request.day
    print "repair_sign_in+++++++++++", day
    response = SignInResponse()

    sign_in_add = base_config.get("signInAdd")
    if not sign_in_add:
        return

    repair_sign_in_times = player.sign_in_component.repair_sign_in_times
    gold = player.finance.gold
    # 校验签到次数
    if repair_sign_in_times == len(sign_in_add):
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
    player.finance.gold -= consume_gold
    player.finance.save_data()
    # 签到奖励

    date = datetime.datetime.now()
    month = date.month

    # 同一天签到校验
    if player.sign_in_component.is_signd(month, day):
        response.res.result = False
        response.res.result_no = 1405
        return response.SerializePartialToString()

    player.sign_in_component.sign_in(month, day)
    player.sign_in_component.save_data()
    if not sign_in_config.get(month) or not sign_in_config.get(month).get(day):
        return
    gain_data = sign_in_config.get(month).get(day)
    return_data = gain(player, gain_data, const.REPAIR_SIGN)
    get_return(player, return_data, response.gain)

    player.sign_in_component.repair_sign_in_times += 1
    player.sign_in_component.save_data()
    response.res.result = True
    return response.SerializePartialToString()
