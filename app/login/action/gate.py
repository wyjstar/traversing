# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.login.model.manager import account_cache, server_manager
from gfirefly.server.globalobject import rootserviceHandle


@rootserviceHandle
def account_verify(key):
    response = {'result': False}
    print 'account verify:', key
    if key in account_cache:
        response['result'] = True
        response['uuid'] = account_cache[key]
    else:
        print account_cache

    print 'acount verify result:', response
    return str(response)


@rootserviceHandle
def server_sync(name, ip, port, status):
    server_manager.sync_server(name, ip, port, status)
    print server_manager.get_server()
