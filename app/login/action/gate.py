# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.login.model.manager import account_cache
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
