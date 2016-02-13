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
from sdk.api.meizu import verify_login


@webserviceHandle('/login_meizu')
def server_meizu_login():
    """ account login """
    token = request.args.get('session_id')
    uid = request.args.get('uid')
    result = verify_login(uid, token)
    logger.debug("meizu login in token:%s uid:%s result:%s" %
                 (token, uid, result))
    if result is False:
        return json.dumps(dict(result=False))

    openid = uid
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
