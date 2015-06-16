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
from sdk.api.tbt.tbt_api import verify_login


@webserviceHandle('/login')
def server_login():
    """ account login """
    logger.info("server_login login in.")
    session = request.args.get('session')
    appid = request.args.get('appid')
    openid = request.args.get('openid')
    logger.debug("session, appid" % (session, appid))
    result = eval(__login(session, appid))
    openid = result.get('ret')
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server(),
                       ret=openid,
                       openid=openid)

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(session, appid):
    """login """
    #res = GlobalObject().msdk.verify_login(int(platform), openid, access_token)
    res = verify_login(session, appid)
    logger.debug(res)
    if res > 0:
        return str({'result': True, 'ret': '\'%s\'' % res})
    return str({'result': False, "ret": res})
