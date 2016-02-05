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
from sdk.api.lenovo import verify_login


@webserviceHandle('/login_lenovo')
def server_lenovo_login():
    """ account login """
    token = request.args.get('lpsust')
    result = verify_login(token)
    logger.debug("lenovo login in token:%s uid:%s result:%s" % (token, result))
    if result is False:
        return json.dumps(dict(result=False))

    openid = '11'
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