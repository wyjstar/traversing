# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import uuid
from gfirefly.server.globalobject import webserviceHandle, rootserviceHandle
from flask import request
import urllib

account_cache = {}


@webserviceHandle('/login')
def server_login():
    """ account login """

    verify_passport = request.args.get('passport')
    result = eval(__login(verify_passport))
    if result.get('result') is False:
        return str({'result': False})

    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = verify_passport
    server1 = {'name': '60', 'port': 11009, 'ip': '192.168.1.60', 'status': 'normal'}
    server2 = {'name': 'cui', 'port': 11009, 'ip': '192.168.1.111', 'status': 'normal'}
    server3 = {'name': 'wang', 'port': 11009, 'ip': '192.168.1.24', 'status': 'normal'}
    server4 = {'name': 'lee', 'port': 11009, 'ip': '192.168.1.181', 'status': 'normal'}

    server_list = {'result': True, 'passport': game_passport,
                   'servers': [server1, server2, server3, server4]}

    print server_list
    return str(server_list)


def __login(passport):
    """login """
    print 'player login passport:%s' % passport
    url_response = urllib.urlopen('http://localhost:20100/verify?passport=%s' % passport)
    str_response = url_response.read()
    response = eval(str_response)
    if response.get('result') is True:
        return str({'result': True, 'account_id': '\'%s\'' % passport})
    return str({'result': False})
