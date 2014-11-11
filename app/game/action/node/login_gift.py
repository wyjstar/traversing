# -*- coding:utf-8 -*-
"""
created by server on 14-9-3下午5:28.
"""
from app.proto_file.login_gift_pb2 import *
from gfirefly.server.globalobject import remoteserviceHandle
from shared.db_opear.configs_data.game_configs import activity_config
from app.game.core.item_group_helper import gain, get_return


@remoteserviceHandle('gate')
def init_login_gift_825(pro_data, player):
    """登录奖励
    """
    response = InitLoginGiftResponse()

    cumulative_received, continuous_received, cumulative_day, continuous_day = init_login_gift(player)
    for i in cumulative_received:
        response.cumulative_received.append(i)

    for i in continuous_received:
        response.continuous_received.append(i)

    response.cumulative_day.login_day = cumulative_day[0]
    response.cumulative_day.is_new_p = cumulative_day[1]

    response.continuous_day.login_day = continuous_day[0]
    response.continuous_day.is_new_p = continuous_day[1]

    return response.SerializeToString()


@remoteserviceHandle('gate')
def get_login_gift_826(pro_data, player):
    """领取登录奖励
    """
    args = GetLoginGiftRequest()
    args.ParseFromString(pro_data)
    activity_id = args.activity_id
    activity_type = args.activity_type
    response = GetLoginGiftResponse()
    res, err_no = get_login_gift(activity_id, activity_type, response, player)
    response.result = res
    if err_no:
            response.result_no = err_no
    return response.SerializeToString()


def init_login_gift(player):
    """
    获取登录活动信息
    """
    return player.login_gift.cumulative_received, player.login_gift.continuous_received,\
        player.login_gift.cumulative_day, player.login_gift.continuous_day


def get_login_gift(activity_id, activity_type, response, player):
    """
    领取登录奖励
    """
    if activity_type == 1:  # 累积登录
        if player.login_gift.cumulative_received.count(activity_id) == 0:  # 未领取
            if player.login_gift.cumulative_day[1]:  # 是新手活动
                res = False
                err_no = 800
                for i in activity_config.get(1):
                    if i.get('id') == activity_id:
                        if i.get('parameterA') <= player.login_gift.cumulative_day[0]:
                            player.login_gift.cumulative_received.append(activity_id)
                            gain_data = i['reward']
                            return_data = gain(player, gain_data)
                            get_return(player, return_data, response.gain)
                            res = True
                            err_no = 0
                        else:
                            res = False
                            err_no = 802  # 条件没有达到

            else:  # 未知错误,不是新手活动的情况，目前代码不应该走这里
                res = False
                err_no = 800
        else:
            res = False
            err_no = 801  # 已经领取过
    else:  # 连续登录奖励
        if player.login_gift.continuous_received.count(activity_id) == 0: # 未领取
            if player.login_gift.continuous_day[1]:  # 是新手活动
                res = False
                err_no = 800
                for i in activity_config.get(2):
                    if i.get('id') == activity_id:
                        if i.get('parameterA') <= player.login_gift.continuous_day[0]:
                            player.login_gift.continuous_received.append(activity_id)
                            gain_data = i['reward']
                            return_data = gain(player, gain_data)
                            get_return(player, return_data, response.gain)
                            res = True
                            err_no = 0
                        else:
                            res = False
                            err_no = 802  # 条件没有达到

            else:  # 未知错误,不是新手活动的情况，目前代码不应该走这里
                res = False
                err_no = 800
        else:
            res = False
            err_no = 801  # 已经领取过
    player.login_gift.save_data()
    return res, err_no
