# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午5:41.
"""
from app.account.service.local.local_service import localservice
from app.account.service.node.gateservice import nodeservice_handle
from app.account.proto_file import account_pb2


@nodeservice_handle
def register_1(command_id, dynamic_id, request_proto):
    """
    @param command_id: 操作编号
    @param dynamic_id: 动态编号
    @param request_proto: 传输数据
    @return: 唯一机器标识 MD5('%s:%s:%s:%s' % (帐号ID, 帐号uuid, 用户名, 密码))
    """
    account_info = account_pb2.AccountInfo()
    account_info.ParseFromString(request_proto)
    account_type = account_info.type
    user_name = account_info.user_name
    password = account_info.password
    key = account_info.key.key

    result = localservice.callTarget(command_id, dynamic_id, account_type, user_name, password, key)
    account_key = account_pb2.AccountResponse()
    account_key.result = result.get('result')
    if result.get('token', None):
        account_key.key.key = result.get('token')

    return account_key.SerializeToString()


@nodeservice_handle
def login_2(command_id, dynamic_id, request_proto):
    """帐号登录
    @param command_id:
    @param dynamic_id:
    @param request_proto:
    @return: 登录成功/失败
    """
    account_key = account_pb2.LoginResquest()
    account_key.ParseFromString(request_proto)
    key = account_key.key.key
    user_name = account_key.user_name
    password = account_key.password

    result = localservice.callTarget(command_id, dynamic_id, key, user_name, password)
    account_response = account_pb2.AccountResponse()
    account_response.result = result.get('result')

    return account_response.SerializeToString()
