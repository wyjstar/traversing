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

from sdk.api.xiaomi.XMHttpClient import XMHttpClient
from sdk.api.xiaomi.XMUtils import XMUtils

host = 'msdk.qq.com'
pay_host = ('10.142.22.11', 8080)
buy_goods_host = ('10.142.22.11', 8080)
valid_host = ('10.130.2.233', 80)

AppId = GlobalObject().allconfig["xmsdk"]["AppId"]
AppKey = GlobalObject().allconfig["xmsdk"]["AppKey"]
AppSecret = GlobalObject().allconfig["xmsdk"]["AppSecret"]
VerifySession_URL = GlobalObject().allconfig["xmsdk"]["VerifySession_URL"]

# print(AppId, AppKey, AppSecret, VerifySession_URL)


@webserviceHandle('/login_xiaomi')
def server_login():
    """ account login """
    logger.info("server_login login in.")
    uid = request.args.get('uid')
    session = request.args.get('session')
    logger.debug("uid, session, %s %s" % (uid, session))
    result = eval(__login(uid, session))
    if result.get('result') is False:
        return json.dumps(dict(result=False))

    game_passport = uuid.uuid1().get_hex()
    manager.account_cache[game_passport] = uid

    server_list = dict(result=True,
                       passport=game_passport,
                       servers=manager.server_manager.get_server())

    logger.debug(server_list)
    return json.dumps(server_list)


def __login(uid, session):
    """login """
    res = verify_login(uid, session)
    logger.debug(res)
    if res.get('errcode') == 200:
        return str({'result': True, 'uid': '\'%s\'' % uid})
    return str({'result': False})


def verify_login(uid, session):
    xm_utils = XMUtils()
    client = XMHttpClient(VerifySession_URL)
    params = dict(appId=AppId, session=session, uid=uid)
    sign = xm_utils.buildSignature(params, AppSecret)
    # headers = xm_utils.buildMacRequestHead(self.accessToken, nonce, sign)
    params["signature"] = sign
    res = client.request("", "GET", params)
    jsonObject = client.safeJsonLoad(res.read())
    return jsonObject
