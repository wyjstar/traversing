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
from gfirefly.server.globalobject import GlobalObject

host = 'msdk.qq.com'
pay_host = ('10.142.22.11', 8080)
buy_goods_host = ('10.142.22.11', 8080)
valid_host = ('10.130.2.233', 80)

qq_appid = 1104297231
qq_appkey = 'y33yRx3FveVZb1dw'
wx_appid = 'wxf77437c08cb06196'
wx_appkey = '8274b9e862581f8b4976ba90ad2d4b77'


@webserviceHandle('/login_tencent')
def qq_server_login():
    """ account login """
    logger.info("server_login login in.")
    openid = request.args.get('open_id')
    access_token = request.args.get('access_token')
    platform = request.args.get('platform')
    logger.debug("open_id, access_token, platform %s %s %s" %
                 (openid, access_token, platform))
    result = eval(__login(platform, openid, access_token))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    manager.account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(platform, openid, access_token):
    """login """
    logger.debug('player login openid:%s access_token %s' %
                 (openid, access_token))
    res = GlobalObject().msdk.verify_login(int(platform), openid, access_token)
    logger.debug(res)
    logger.debug(res)
    if res == 0:
        return str({'result': True, 'account_id': '\'%s\'' % openid})
    return str({'result': False})
