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
from sdk.api.lenovo import verify_login


@webserviceHandle('/login_lenovo')
def server_lenovo_login():
    """ account login """
    token = request.args.get('access_token')
    result = verify_login(token)
    logger.debug("lenovo login in token:%s result:%s", token, result)
    if result is '':
        return json.dumps(dict(result=False))

    openid = result
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
