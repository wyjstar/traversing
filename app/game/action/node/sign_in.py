# -*- coding:utf-8 -*-
"""
签到
created by server on 14-8-25下午8:29.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.sign_in import sign_in, continuous_sign_in, repair_sign_in
from app.proto_file.sign_in_pb2 import SignInRequest, ContinuousSignInRequest


@remote_service_handle
def get_sign_in_1401(dynamic_id, pro_data):
    """获取签到信息"""


@remote_service_handle
def sign_in_1401(dynamic_id, pro_data):
    """签到"""
    request = SignInRequest()
    request.ParseFromString(pro_data)
    return sign_in(dynamic_id, request.month, request.day)


@remote_service_handle
def continus_sign_in_1402(dynamic_id, pro_data):
    """连续签到"""
    request = ContinuousSignInRequest()
    request.ParseFromString(pro_data)
    return continuous_sign_in(dynamic_id, request.month, request.day)


@remote_service_handle
def repair_sign_in_1403(dynamic_id, pro_data):
    """补充签到"""
    return repair_sign_in(dynamic_id)