# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午5:41.
"""
from app.account.service.node.gateservice import node_service_handle
import hashlib
from app.account.model.sequence import get_id
from app.account.redis_mode import tb_account
from app.account.redis_mode import tb_account_mapping
from gfirefly.utils.pyuuid import get_uuid


@node_service_handle
def register_1(command_id, dynamic_id, account_type, user_name, password, key):
    if account_type == 1:  # 游客注册
        return __guest_register()
    if account_type == 2:  # 帐号注册
        return __account_register(user_name, password)
    if account_type == 3:  # 绑定帐号
        return __binding_register(user_name, password, key)


@node_service_handle
def login_2(command_id, dynamic_id, key, user_name, password):
    """登录
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
    key = account_info.key.keyload_module

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
>>>>>>> Stashed changes
    """
    account_id = None  # 帐号ID
    mapping_data = tb_account_mapping.getObjData(key)  # 帐号匹配信息
    if mapping_data:
        account_id = mapping_data.get('id', None)

    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    # 用户名，密码校验
    if user_name and password:
        account_data = tb_account.getObjData(account_id)
        _user_name = account_data.get('account_name', None)
        _password = account_data.get('account_password', None)
        if (user_name != _user_name) or (password != _password):
            return {'result': False}

    return {'result': True, 'account_id': account_id}


def __guest_register():
    account_id = get_id()
    uuid = get_uuid()
    data = dict(id=account_id, uuid=uuid, account_name=None, account_password=None, last_login=0)
    account_mmode = tb_account.new(data)
    account_mmode.insert()
    md5 = hashlib.md5()
    md5.update('%s:%s' % (account_id, uuid))
    token = md5.hexdigest()
    data = dict(id=account_id, account_token=token)
    account_mapping = tb_account_mapping.new(data)
    account_mapping.insert()

    print 'register:', tb_account_mapping.getObjData(token)

    return {'result': True, 'token': token, 'account_id': account_id}


def __account_register(user_name, password):
    # TODO 校验
    account_id = get_id()
    uuid = get_uuid()
    data = dict(id=account_id, uuid=uuid, account_name=user_name, account_password=password, last_login=0)
    account_mmode = tb_account.new(data)
    account_mmode.insert()
    md5 = hashlib.md5()
    md5.update('%s:%s' % (account_id, uuid))
    token = md5.hexdigest()
    data = dict(id=account_id, account_token=token)
    account_mapping = tb_account_mapping.new(data)
    account_mapping.insert()

    return {'result': True, 'token': token, 'account_id': account_id}


def __binding_register(user_name, password, key):
    # TODO 校验
    account_id = None
    mapping_data = tb_account_mapping.getObjData(key)
    if mapping_data:
        account_id = mapping_data.get('id', None)
        account_uuid = mapping_data.get('uuid')

    if not account_id:
        return {'result': False}

    account_obj = tb_account.getObj(account_id)
    update_dict = {'user_name': user_name, 'password': password}
    account_obj.update_multi(update_dict)
    md5 = hashlib.md5()
    md5.update('%s:%s:%s:%s' % (account_id, account_uuid, user_name, password))
    token = md5.hexdigest()

    return {'result': True, 'token': token, 'account_id': account_id}





















