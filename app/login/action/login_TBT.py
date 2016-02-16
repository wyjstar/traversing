# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
from flask import request
from app.login.model import manager
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger
from sdk.api.tbt.tbt_api import verify_login

APP_ID = GlobalObject().allconfig['msdk']['appid']


@webserviceHandle('/login_tbt')
def tbt_server_login():
    """ account login """
    logger.info("server_login login in.")
    print request.args
    session = request.args.get('access_token')
    logger.debug("session:%s" % session)
    result = eval(__login(session, APP_ID))
    openid = result.get('ret')
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    manager.account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(session, appid):
    """login """
    res = verify_login(session, appid)
    logger.debug(res)
    if res > 0:
        return str({'result': True, 'ret': '\'%s\'' % res})
    return str({'result': False, "ret": res})
