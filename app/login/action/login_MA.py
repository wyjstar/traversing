# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
import urllib
from flask import request
from app.login.model.manager import account_cache
from app.login.model import manager
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject


SERVERS_MA_WEBPORT = GlobalObject().allconfig['servers']['MA']['webport']
SERVER_MA_URL = GlobalObject().json_config['MA_url']


@webserviceHandle('/login')
def server_login():
    """ account login """

    logger.debug('server_login======================')
    verify_passport = request.args.get('passport')
    result = eval(__login(verify_passport))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = verify_passport

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(passport):
    """login """
    logger.info('player login passport:%s' % passport)
    url = '%s:%s' % (SERVER_MA_URL, SERVERS_MA_WEBPORT)
    url_response = urllib.urlopen('%s/verify?passport=%s' % (url, passport))
    str_response = url_response.read()
    response = eval(str_response)
    if response.get('result') is True:
        return str({'result': True, 'account_id': '\'%s\'' % passport})
    return str({'result': False})
