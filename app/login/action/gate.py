# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
from app.login.model import manager
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.logobj import logger


@rootserviceHandle
def account_verify_remote(key):
    response = {'result': False}
    logger.info('account verify:%s', key)
    if key in manager.account_cache:
        response['result'] = True
        response['uuid'] = manager.account_cache[key]
    else:
        logger.debug(manager.account_cache)

    logger.info('acount verify result:%s', response)
    return str(response)


@rootserviceHandle
def server_sync_remote(name, ip, port, status, server_no):
    manager.server_manager.sync_server(name, ip, port, status, server_no)
    logger.info(manager.server_manager.get_server())
