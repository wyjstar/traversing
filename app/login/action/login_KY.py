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
from sdk.api.kuaiyong import verify_login


@webserviceHandle('/login_ky')
def ky_server_login():
    """ account login """
    token = request.args.get('open_id')
    result = __login(token)
    logger.debug("kuaiyong login in token:%s result:%s" % (token, result))
    if result.get('code') != 0:
        return json.dumps(dict(result=False))

    result_data = result.get('data')
    openid = result_data.get('guid')
    user_name = result_data.get('username')
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
