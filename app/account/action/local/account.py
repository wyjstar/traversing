# -*- coding:utf-8 -*-
"""
created by server on 14-6-5下午8:07.
"""
import hashlib
from app.account.model.sequence import get_id
from app.account.redis_mode import tb_account
from app.account.redis_mode import tb_account_mapping
from app.account.service.local.local_service import localservice_handle
from gfirefly.utils.pyuuid import get_uuid
import cPickle

@localservice_handle
def register_1(command_id, dynamic_id, account_type, user_name, password, key):
    if account_type == 1:  # 游客注册
        return __guest_register()
    if account_type == 2:  # 帐号注册
        return __account_register(user_name, password)
    if account_type == 3:  # 绑定帐号
        return __binding_register(user_name, password, key)


@localservice_handle
def login_2(command_id, dynamic_id, key, user_name, password):
    account_id = None
    mapping_data = tb_account_mapping.getObjData(key)
    if mapping_data:
        account_id = mapping_data.get('id', None)  # 取得帐号ID
    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    if user_name and password:
        account_data = tb_account.getObjData(account_id)
        print 'account_data:', account_data
        _user_name = account_data.get('account_name', None)
        _password = account_data.get('account_password', None)

        print user_name, _user_name, password, _password
        # 帐号名或者密码错误
        if (user_name != _user_name) or (password != _password):
            return {'result': False}

    return {'result': True}


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
    return {'result': True, 'token': token}


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
    return {'result': True, 'token': token}


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
    return {'result':True, 'token':token}



















