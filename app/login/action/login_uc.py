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
from sdk.api.uc import verify_login


@webserviceHandle('/login_uc')
def server_uc_login():
    """ account login """
    sid = request.args.get('sid')
    result = __login(sid)
    logger.debug("uc login in sid:%s result:%s" % (sid, result))
    if result is None or 'error' in result:
        return json.dumps(dict(result=False))

    openid = result['data']['accountId']
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


def __login(sid):
    """login """
    res = verify_login(sid)
    # logger.debug(res)
    return res
