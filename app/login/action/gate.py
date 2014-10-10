# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.login.model.manager import account_cache, server_manager
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.logobj import logger


@rootserviceHandle
def account_verify(key):
    response = {'result': False}
    logger.info('account verify:%s', key)
    if key in account_cache:
        response['result'] = True
        response['uuid'] = account_cache[key]
    else:
        logger.debug(account_cache)

    logger.info('acount verify result:%s', response)
    return str(response)


@rootserviceHandle
def server_sync(name, ip, port, status):
    server_manager.sync_server(name, ip, port, status)
    logger.info(server_manager.get_server())
