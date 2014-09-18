# -*- coding:utf-8 -*-
"""
created by server on 14-9-3下午5:28.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.login_gift import *
from app.proto_file.login_gift_pb2 import *


@remote_service_handle
def init_login_gift_825(dynamic_id, pro_data):
    """登录奖励
    """
    response = InitLoginGiftResponse()

    cumulative_received, continuous_received, cumulative_day, continuous_day = init_login_gift(dynamic_id)
    for i in cumulative_received:
        response.cumulative_received.append(i)

    for i in continuous_received:
        response.continuous_received.append(i)

    response.cumulative_day.login_day = cumulative_day[0]
    response.cumulative_day.is_new_p = cumulative_day[1]

    response.continuous_day.login_day = continuous_day[0]
    response.continuous_day.is_new_p = continuous_day[1]

    return response.SerializeToString()


@remote_service_handle
def get_login_gift_826(dynamic_id, pro_data):
    """领取登录奖励
    """
    args = GetLoginGiftRequest()
    args.ParseFromString(pro_data)
    activity_id = args.activity_id
    activity_type = args.activity_type
    response = GetLoginGiftResponse()
    res, err_no = get_login_gift(dynamic_id, activity_id, activity_type, response)
    response.result = res
    if err_no:
            response.result_no = err_no
    return response.SerializeToString()