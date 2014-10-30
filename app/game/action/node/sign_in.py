# -*- coding:utf-8 -*-
"""
签到
created by server on 14-8-25下午8:29.
"""
from app.game.logic.sign_in import sign_in, continuous_sign_in, repair_sign_in, get_sign_in
from app.proto_file.sign_in_pb2 import RepairSignInRequest, ContinuousSignInRequest
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def get_sign_in_1400(dynamic_id, pro_data):
    """获取签到信息"""
    return get_sign_in(dynamic_id)


@remoteserviceHandle('gate')
def sign_in_1401(dynamic_id, pro_data):
    """签到"""
    return sign_in(dynamic_id)


@remoteserviceHandle('gate')
def continus_sign_in_1402(dynamic_id, pro_data):
    """连续签到"""
    request = ContinuousSignInRequest()
    request.ParseFromString(pro_data)
    return continuous_sign_in(dynamic_id, request.sign_in_days)


@remoteserviceHandle('gate')
def repair_sign_in_1403(dynamic_id, pro_data):
    """补充签到"""
    request = RepairSignInRequest()
    request.ParseFromString(pro_data)
    return repair_sign_in(dynamic_id, request.day)