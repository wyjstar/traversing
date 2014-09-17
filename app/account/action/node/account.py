# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午5:41.
"""
import hashlib

from app.account.service.node.gateservice import node_service_handle
from app.account.model.sequence import get_id
from app.account.redis_mode import tb_account
from app.account.redis_mode import tb_account_mapping
# from app.account.redis_mode import tb_name_mapping
from shared.utils.pyuuid import get_uuid
import time


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
    """
    # return {'result': True, 'account_id': 12345+dynamic_id}
    print 'player login user:%s pwd:%s key:%s' % (user_name, password, key)
    account_id = None  # 帐号ID
    mapping_data = tb_account_mapping.getObjData(key)  # 帐号匹配信息
    if mapping_data:
        account_id = mapping_data.get('id', None)
    else:
        print 'key is not exist'

    # if not account_id and user_name and password:
    #     name_mapping_data = tb_name_mapping.getObjData(user_name)
    #     print name_mapping_data
    #     if name_mapping_data:
    #         用户名，密码校验
            # account_id = name_mapping_data.get('id')
            # account_data = tb_account.getObjData(account_id)
            # _user_name = account_data.get('account_name', None)
            # _password = account_data.get('account_password', None)
            # if (user_name != _user_name) or (password != _password):
            #     print 'user or pwd is error!'
            #     return {'result': False}

    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    return {'result': True, 'account_id': account_id, 'key': key}


def __guest_register():
    account_id = get_id()
    uuid = get_uuid()
    data = dict(id=account_id, uuid=uuid, account_name=None, account_password=None, last_login=0,
                create_time=int(time.time()))
    account_mmode = tb_account.new(data)
    account_mmode.insert()
    md5 = hashlib.md5()
    md5.update('%s:%s' % (account_id, uuid))
    token = md5.hexdigest()
    data = dict(id=account_id, account_token=token)
    account_mapping = tb_account_mapping.new(data)
    account_mapping.insert()

    return {'result': True, 'token': token, 'account_id': account_id}


def __account_register(user_name, password):
    # TODO 校验

    if not __check_register_name(user_name):
        print 'user is exist user', user_name
        return {'result': False}

    account_id = get_id()
    uuid = get_uuid()
    data = dict(id=account_id, uuid=uuid, account_name=user_name, account_password=password, last_login=0,
                create_time=int(time.time()))
    account_mmode = tb_account.new(data)
    account_mmode.insert()

    md5 = hashlib.md5()
    md5.update('%s:%s' % (account_id, uuid))
    token = md5.hexdigest()
    data = dict(id=account_id, account_token=token)
    account_mapping = tb_account_mapping.new(data)
    account_mapping.insert()

    data = dict(account_name=user_name, id=account_id)
    # name_mapping = tb_name_mapping.new(data)
    # name_mapping.insert()

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


def __check_register_name(user_name):
    # mapping_data = tb_name_mapping.getObjData(user_name)
    # if not mapping_data:
    #     return True

    return False























