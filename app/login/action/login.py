# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import webserviceHandle
from app.proto_file import account_pb2
from app.login.model import tb_account_mapping
from app.login.model import tb_name_mapping
from app.login.model import tb_account


@webserviceHandle('/<key>')
def server_login_2(key):
    """ account login """

    # 登录数据解析
    # account_key = account_pb2.AccountLoginRequest()
    # account_key.ParseFromString(request_proto)
    # key = account_key.key.key
    # user_name = account_key.user_name
    # password = account_key.password

    result = login(key)
    print result
    account_key = account_pb2.AccountResponse()
    account_key.result = result.get('result')
    if result.get('token', None):
        account_key.key.key = result.get('token')

        server_add = account_key.serverlist.add()
        server_add.name = '60'
        server_add.ip = '192.168.1.60'
        server_add.port = '11009'
        server_add.status = 'normal'
        server_add = account_key.serverlist.add()
        server_add.name = 'cui'
        server_add.ip = '192.168.10.111'
        server_add.port = '11009'
        server_add.status = 'normal'
        server_add = account_key.serverlist.add()
        server_add.name = 'wang'
        server_add.ip = '192.168.1.24'
        server_add.port = '11009'
        server_add.status = 'normal'
        server_add = account_key.serverlist.add()
        server_add.name = 'lee'
        server_add.ip = '192.168.1.181'
        server_add.port = '11009'
        server_add.status = 'normal'

    return account_key.SerializeToString()


def login(key):
    """login """

    print 'player login user:%s pwd:%s key:%s' % key
    account_id = None  # 帐号ID
    mapping_data = tb_account_mapping.getObjData(key)  # 帐号匹配信息
    if mapping_data:
        account_id = mapping_data.get('id', None)
    else:
        print 'key is not exist'

    if not account_id:
        print 'user or pwd is error!'
        return {'result': False}
        # name_mapping_data = tb_name_mapping.getObjData(user_name)
        # print name_mapping_data
        # if name_mapping_data:
        #     # 用户名，密码校验
        #     account_id = name_mapping_data.get('id')
        #     account_data = tb_account.getObjData(account_id)
        #     _user_name = account_data.get('account_name', None)
        #     _password = account_data.get('account_password', None)
        #     if (user_name != _user_name) or (password != _password):
        #         print 'user or pwd is error!'
        #         return {'result': False}

    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    return {'result': True, 'account_id': account_id, 'key': key}
