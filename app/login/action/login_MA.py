# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
import urllib
from flask import request
from app.login.model.manager import account_cache, server_manager
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger


@webserviceHandle('/login')
def server_login():
    """ account login """

    verify_passport = request.args.get('passport')
    result = eval(__login(verify_passport))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = verify_passport

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(passport):
    """login """
    logger.info('player login passport:%s' % passport)
    url_response = urllib.urlopen('http://localhost:20100/verify?passport=%s' % passport)
    str_response = url_response.read()
    response = eval(str_response)
    if response.get('result') is True:
        return str({'result': True, 'account_id': '\'%s\'' % passport})
    return str({'result': False})
