# -*- coding:utf-8 -*-
"""
created by server on 14-8-25下午8:31.
"""
from shared.db_opear.configs_data.game_configs import sign_in_config, base_config
from app.game.logic.item_group_helper import gain, get_return
from app.proto_file.sign_in_pb2 import SignInResponse, ContinuousSignInResponse, GetSignInResponse
from app.proto_file.common_pb2 import CommonResponse
from app.game.core.drop_bag import BigBag
from app.game.logic.common.check import have_player
import datetime


@have_player
def get_sign_in(dynamic_id, **kwargs):
    player = kwargs.get('player')
    response = GetSignInResponse()
    sign_in_component = player.sign_in_component
    [response.days.append(i) for i in sign_in_component.sign_in_days]
    response.continuous_sign_in_days = sign_in_component.continuous_sign_in_days
    [response.continuous_sign_in_prize.append(i) for i in sign_in_component.continuous_sign_in_prize]
    response.repair_sign_in_times = sign_in_component.repair_sign_in_times
    return response.SerializePartialToString()

@have_player
def sign_in(dynamic_id, month, day, **kwargs):
    """签到"""
    player = kwargs.get('player')
    response = SignInResponse()

    # 签到
    player.sign_in_component.sign_in(datetime.datetime.now())
    player.sign_in_component.save_data()
    # 获取奖励

    if not sign_in_config.get(month) or not sign_in_config.get(month).get(day):
        print "sign_in_config 配置文件信息不足！", sign_in_config
    gain_data = sign_in_config.get(month).get(day)
    return_data = gain(player, gain_data)
    get_return(player, return_data, response.gain)
    response.res.result = True
    return response.SerializePartialToString()


@have_player
def continuous_sign_in(dynamic_id, days, **kwargs):
    """连续签到"""
    player = kwargs.get('player')
    response = ContinuousSignInResponse()

    sign_in_prize = base_config.get("signInPrize")
    if not sign_in_prize:
        print "base_config 信息不足！"
    # 验证连续签到日期
    if player.sign_in_component.continuous_sign_in_days < days \
            and days in player.sign_in_component.continuous_sign_in_days:
        response.result = False
        response.result_no = 1402
        print "连续签到日期不足", days
        return response.SerializePartialToString()
    if days in player.sign_in_component.continuous_sign_in_prize:
        response.result = False
        response.result_no = 1403
        print "已经领取连续签到奖励", days
        return response.SerializePartialToString()

    player.sign_in_component.continuous_sign_in_prize.append(days)
    player.sign_in_component.save_data()

    drop_bag_id = sign_in_prize.get(days)
    big_bag = BigBag(drop_bag_id)
    gain_data = big_bag.get_drop_items()
    return_data = gain(player, gain_data)
    get_return(player, return_data, response.gain)

    response.res.result = True
    return response.SerializePartialToString()


@have_player
def repair_sign_in(dynamic_id, **kwargs):
    """补充签到"""
    player = kwargs.get('player')
    response = CommonResponse()

    sign_in_add = base_config.get("signInAdd")
    if not sign_in_add:
        print "base_config 配置文件信息不足！", base_config

    repair_sign_in_times = player.sign_in_component.repair_sign_in_times
    gold = player.finance.gold
    # 校验签到次数
    if repair_sign_in_times == sign_in_add:
        response.res.result = False
        response.res.result_no = 1404
        return response.SerializePartialToString()
    # 校验消耗元宝数
    consume_gold = sign_in_add[repair_sign_in_times]
    if consume_gold > gold:
        response.res.result = False
        response.res.result_no = 1405
        return response.SerializePartialToString()
    # 消耗
    player.finance.gold -= consume_gold
    player.finance.save_data()
    player.sign_in_component.repair_sign_in_times += 1
    player.sign_in_component.save_data()
    response.result = True
    return response.SerializePartialToString()