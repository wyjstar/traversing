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
from sdk.api.huawei import verify_login


@webserviceHandle('/login_huawei')
def server_huawei_login():
    """ account login """
    token = request.args.get('access_token')
    result = __login(token)
    logger.debug("huawei login in token:%s result:%s" % (token, result))
    if result is None or 'error' in result:
        return json.dumps(dict(result=False))

    openid = result.get('userID')
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


def __login(token):
    """login """
    res = verify_login(token)
    # logger.debug(res)
    return res
