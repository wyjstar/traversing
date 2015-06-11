# -*- coding:utf-8 -*-
"""
created by server on 14-9-3下午5:28.
"""
from app.proto_file.login_gift_pb2 import *
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from gfirefly.server.logobj import logger
from shared.utils.const import const


@remoteserviceHandle('gate')
def init_login_gift_825(pro_data, player):
    """登录奖励
    """
    response = InitLoginGiftResponse()

    for k, v in player.login_gift.cumulative_day.item():
        temp_pb = response.cumulative_day.add()
        temp_pb.activity_id = k
        temp_pb.state = v

    for k, v in player.login_gift.continuous_day.item():
        temp_pb = response.continuous_day.add()
        temp_pb.activity_id = k
        temp_pb.state = v

    response.continuous_day_num = player.login_gift.continuous_day_num
    response.cumulative_day_num = player.login_gift.cumulative_day_num

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_login_gift_826(pro_data, player):
    """领取登录奖励
    """
    args = GetLoginGiftRequest()
    args.ParseFromString(pro_data)
    activity_id = args.activity_id
    #activity_type = args.activity_type
    response = GetLoginGiftResponse()
    res, err_no = get_login_gift(activity_id, response, player)
    response.result = res
    if err_no:
            response.result_no = err_no
    return response.SerializeToString()


def get_login_gift(activity_id, response, player):
    """
    领取登录奖励
    """
    if not player.login_gift.is_open(activity_type):
        logger.error("login gift activity closed.")
        return False, 82601
    activity_info = game_configs.activity_config.get(activity_id)
    if not activity_info:
        logger.error("can not find activity_config by id %s" % activity_id)
        return False, 82604

    if activity_info.activity_type == 1:
        # 累积登录
        parameterA = activity_info.parameterA
        cumulative_day = player.login_gift.cumulative_day

        if parameterA > len(player.login_gift.cumulative_day):
            return False, 82602

        if cumulative_day[activity_id] != 0:
            logger.error("current activity_info state %s" % cumulative_day[activity_id])
            return False, 82603

        return_data = gain(player, activity_info.reward, const.LOGIN_GIFT_CONTINUS)
        get_return(player, return_data, response.gain)
        player.login_gift.cumulative_day[activity_id] = 1
        player.login_gift.save_data()

        return True, 0

    elif activity_info.activity_type == 2:
        # 连续登录
        parameterA = activity_info.parameterA
        continuous_day = player.login_gift.continuous_day

        if parameterA > len(player.login_gift.continuous_day):
            return False, 82612

        if continuous_day[activity_id] != 0:
            logger.error("current activity_info state %s" % continuous_day[activity_id])
            return False, 82613

        return_data = gain(player, activity_info.reward)
        get_return(player, return_data, response.gain, const.LOGIN_GIFT_CUMULATIVE)
        player.login_gift.continuous_day[activity_id] = 1
        player.login_gift.continuous_day_num += 1
        player.login_gift.save_data()
        return True, 0

