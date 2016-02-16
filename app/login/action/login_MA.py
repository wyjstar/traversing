# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
from flask import request
from app.login.model import manager
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
from geventhttpclient import HTTPClient
from geventhttpclient.url import URL

SERVERS_MA_WEBPORT = GlobalObject().allconfig['servers']['MA']['webport']
SERVER_MA_URL = GlobalObject().json_config['MA_url']


@webserviceHandle('/login')
def ma_server_login():
    """ account login """

    logger.debug('server_login======================')
    verify_passport = request.args.get('passport')
    result = eval(__login(verify_passport))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    manager.account_cache[game_passport] = verify_passport

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(passport):
    """login """
    logger.info('player login passport:%s' % passport)
    domain = '%s:%s' % (SERVER_MA_URL, SERVERS_MA_WEBPORT)
    url = '%s/verify?passport=%s' % (domain, passport)
    url = URL(url)
    http = HTTPClient(url.host, port=url.port)
    response = eval(http.get(url.request_uri).read())
    http.close()
    if response.get('result') is True:
        return str({'result': True, 'account_id': '\'%s\'' % passport})
    return str({'result': False})
