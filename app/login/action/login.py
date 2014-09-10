# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import netserviceHandle
from app.proto_file import account_pb2
from app.login.model import tb_account_mapping
from app.login.model import tb_name_mapping
from app.login.model import tb_account


@netserviceHandle
def server_login_2(command_id, dynamic_id, request_proto):
    """ account login """
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

    # 登录数据解析
    account_key = account_pb2.AccountLoginRequest()
    account_key.ParseFromString(request_proto)
    key = account_key.key.key
    user_name = account_key.user_name
    password = account_key.password

    # 通知帐号服
    # result = GlobalObject().root.callChild('account',
    #                                        command_id,
    #                                        dynamic_id,
    #                                        key,
    #                                        user_name,
    #                                        password)

    result = login(command_id, dynamic_id, key, user_name, password)
    print result
    account_key = account_pb2.AccountResponse()

    return account_key.SerializeToString()


def login(command_id, dynamic_id, key, user_name, password):
    """login """

    print 'player login user:%s pwd:%s key:%s' % (user_name, password, key)
    account_id = None  # 帐号ID
    mapping_data = tb_account_mapping.getObjData(key)  # 帐号匹配信息
    if mapping_data:
        account_id = mapping_data.get('id', None)
    else:
        print 'key is not exist'

    if not account_id and user_name and password:
        name_mapping_data = tb_name_mapping.getObjData(user_name)
        print name_mapping_data
        if name_mapping_data:
            # 用户名，密码校验
            account_id = name_mapping_data.get('id')
            account_data = tb_account.getObjData(account_id)
            _user_name = account_data.get('account_name', None)
            _password = account_data.get('account_password', None)
            if (user_name != _user_name) or (password != _password):
                print 'user or pwd is error!'
                return {'result': False}

    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    return {'result': True, 'account_id': account_id, 'key': key}
