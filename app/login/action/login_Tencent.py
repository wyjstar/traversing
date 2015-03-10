# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import uuid
import urllib
from flask import request
from app.login.model.manager import account_cache, server_manager
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.logobj import logger
from sdk.api.tencent.msdk import Msdk
from sdk.util import logger_sdk

host = 'msdk.qq.com'
pay_host = ('10.142.22.11', 8080)
buy_goods_host = ('10.142.22.11', 8080)
valid_host = ('10.130.2.233', 80)

qq_appid = 1104297231
qq_appkey = 'y33yRx3FveVZb1dw'
wx_appid = 'wxf77437c08cb06196'
wx_appkey = '8274b9e862581f8b4976ba90ad2d4b77'

pay_host = ('10.142.22.11', 8080)
goods_host = ('10.142.22.11', 8080)
valid_host = ('10.130.2.233', 80)
wx_rank_host = ('api.weixin.qq.com', 80)
qq_rank_host = ('10.153.96.115', 10000)

@webserviceHandle('/login')
def server_login():
    """ account login """
    openid = request.args.get('openid')
    access_token = request.args.get('accessToken')
    platform = request.args.get('platform')
    result = eval(__login(platform, openid, access_token))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    account_cache[game_passport] = openid

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(platform, openid, access_token):
    """login """
    logger.debug('player login openid:%s access_token %s' % (openid, access_token))
    log = logger_sdk.new_log('TxApi')
    msdk = Msdk(host, qq_appid, qq_appkey, wx_appid, wx_appkey, log=log)
    res = msdk.verify_login(platform, openid, access_token)
    logger.debug(res)
    if res.get('ret') == 0:
        return str({'result': True, 'account_id': '\'%s\'' % openid})
    return str({'result': False})
