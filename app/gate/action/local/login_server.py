# -*- coding:utf-8 -*-
"""
created by server on 14-6-28下午4:08.
"""
from app.gate.action.node import net
from app.gate.core.user import User
from app.gate.core.users_manager import UsersManager
from app.proto_file import account_pb2
from app.gate.service.local.gateservice import local_service_handle
from gfirefly.server.globalobject import GlobalObject
from shared.data_collection.static_api import write


@local_service_handle
def server_register_1(command_id, dynamic_id, request_proto):
    """帐号注册
    """
    # 注册数据解析
    account_info = account_pb2.AccountInfo()
    account_info.ParseFromString(request_proto)
    account_type = account_info.type
    user_name = account_info.user_name
    password = account_info.password
    key = account_info.key.key

    # 通知帐号服
    result = GlobalObject().root.callChild('account', command_id, dynamic_id, account_type, user_name, password, key)
    print 'result', result

    if result.get('result', True):  # 注册成功
        account_id = result.get('account_id')
        __manage_user(key, account_id, user_name, password, dynamic_id)

    account_key = account_pb2.AccountResponse()
    account_key.result = result.get('result')
    if result.get('token', None):
        account_key.key.key = result.get('token')

    return account_key.SerializeToString()


@local_service_handle
def server_login_2(command_id, dynamic_id, request_proto):
    """ 帐号登录
    @param command_id:
    @param dynamic_id:
    @param request_proto:
    @return:
    """
    # account_key = account_pb2.AccountLoginRequest()
    # account_key.ParseFromString(request_proto)
    # key = account_key.key.key
    # user_name = account_key.user_name
    # password = account_key.password
    # print 'key', key
    # print 'user_name', user_name
    # print 'password', password
    # account_key = account_pb2.AccountResponse()
    # account_key.result = True
    # return account_key.SerializeToString()


    #TODO
    # for i in range(100):
    #     write()

    # 登录数据解析
    account_key = account_pb2.AccountLoginRequest()
    account_key.ParseFromString(request_proto)
    key = account_key.key.key
    user_name = account_key.user_name
    password = account_key.password

    # 通知帐号服
    result = GlobalObject().root.callChild('account', command_id, dynamic_id, key, user_name, password)
    print result
    account_key = account_pb2.AccountResponse()
    is_login = result.get('result')

    if is_login:  # 登录成功
        account_id = result.get('account_id')
        account_key.result = __manage_user(key, account_id, user_name, password, dynamic_id)
    else:
        account_key.result = is_login
    return account_key.SerializeToString()


def __manage_user(token, account_id, user_name, password, dynamic_id):
    """管理用户
    """
    user = UsersManager().get_by_id(account_id)
    if user and user.dynamic_id != dynamic_id:
        print 'user exit! info:', user
        if not net.change_dynamic_id(user.dynamic_id, dynamic_id):
            print 'error!, change user id fail, dynamic:', user.dynamic_id
            return False
        # user.dynamic_id = dynamic_id
    else:
        user = User(token, account_id, user_name, password, dynamic_id)
        UsersManager().add_user(user)
    return True
