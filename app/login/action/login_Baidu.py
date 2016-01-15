# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
from flask import request
from app.login.model.manager import account_cache
from app.login.model import manager
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger
from sdk.api.baidu import verify_login


@webserviceHandle('/login_baidu')
def server_baidu_login():
    """ account login """
    token = request.args.get('access_token')
    result = __login(token)
    logger.debug("baidu login in token:%s result:%s" % (token, result))
    if 'error' in result or result is None:
        return json.dumps(dict(result=False))

    openid = result.get('UID')
    user_name = ''
    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       openid=openid,
                       username=user_name,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(token):
    """login """
    res = verify_login(token)
    # logger.debug(res)
    return res
