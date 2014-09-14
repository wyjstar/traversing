# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from gfirefly.server.globalobject import webserviceHandle
from app.login.model import tb_account_mapping
from flask import request
import urllib


@webserviceHandle('/login')
def server_login():
    """ account login """

    passport = request.args.get('passport')
    result = verify(passport)
    print result
    if result == False:
        return {'result': False}

    server1 = {'name': '60', 'port': 11009, 'ip': '192.168.1.60', 'status': 'normal'}
    server2 = {'name': 'cui', 'port': 11009, 'ip': '192.168.1.111', 'status': 'normal'}
    server3 = {'name': 'wang', 'port': 11009, 'ip': '192.168.1.24', 'status': 'normal'}
    server4 = {'name': 'lee', 'port': 11009, 'ip': '192.168.1.181', 'status': 'normal'}

    server_list = {'result': True, 'servers': [server1, server2, server3, server4]}

    print server_list
    return str(server_list)


def verify(passport):
    """login """
    print 'player login passport:%s' % passport
    url_response = urllib.urlopen('http://localhost:20100/verify?passport=%s' % passport)
    str_response = url_response.read()
    response = eval(str_response)
    print response
    if response.get('result') == True:
        return True
    return False

    account_id = None  # 帐号ID
    mapping_data = tb_account_mapping.getObjData(passport)  # 帐号匹配信息
    if mapping_data:
        account_id = mapping_data.get('id', None)
    else:
        print 'key is not exist'

    if not account_id:
        print 'user or pwd is error!'
        return {'result': False}

    #  没有帐号ID，登录错误
    if not account_id:
        return {'result': False}

    return {'result': True, 'account_id': account_id, 'key': passport}
