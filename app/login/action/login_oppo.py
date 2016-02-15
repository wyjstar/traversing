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
from sdk.api.oppo import verify_login


@webserviceHandle('/login_oppo')
def server_oppo_login():
    """ account login """
    token = request.args.get('token')
    ssoid = request.args.get('ssoid')
    result = __login(token, ssoid)
    logger.debug("oppo login in token:%s ssoid:%s result:%s" % (token, ssoid, result))
    if result is None or 'error' in result:
        return json.dumps(dict(result=False))

    openid = result['ssoid']
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


def __login(token, ssoid):
    """login """
    res = verify_login(token, ssoid)
    # logger.debug(res)
    return res
