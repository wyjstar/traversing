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
from sdk.api.vivo import verify_login


@webserviceHandle('/login_vivo')
def server_vivo_login():
    """ account login """
    token = request.args.get('access_token')
    result = verify_login(token)
    logger.debug("vivo login in token:%s result:%s" % (token, result))
    if result is None or 'uid' not in result:
        return json.dumps(dict(result=False))

    openid = result.get('uid')
    user_name = ''
    game_passport = uuid.uuid1().get_hex()
    manager.account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       openid=openid,
                       username=user_name,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)
