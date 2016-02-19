# -*- coding:utf-8 -*-
"""
created by sphinx on
"""

import json
import urllib2
import hashlib
from gfirefly.server.logobj import logger
from sdk.func import xtime


GAME_ID = 662038
CP_ID = 26311
API_KEY = '318f3821d8429d2919e96032a655b33d'
TEST_URL = "http://sdk.test4.g.uc.cn/cp/account.verifySession"
OFFICIAL_URL = "http://sdk.g.uc.cn/cp/account.verifySession"


def request_url(url, data):
    """
    请求url
    """
    req = urllib2.Request(url)
    response = None
    try:
        result = urllib2.urlopen(req, data=data)
        response = result.read()
    except Exception, e:
        logger.error(e)
    return response


def verify_login(sid):
    """
    登录校验
    """
    sign = hashlib.md5("sid=%s%s"%(sid,API_KEY)).hexdigest()
    body_data = {'id':xtime.timestamp(),
                 'data':{'sid':sid},
                 'game':{'gameId':GAME_ID},
                 'sign':sign}
    result = request_url(TEST_URL, json.dumps(body_data))
    if result:
        js = json.loads(result)
        if js['id'] == body_data['id'] and js['state']['code'] == 1:
            return js

    logger.error(result)
    return None

def check_sign(data, sign):
    """
    验证签名
    """
    accountId = data['accountId']
    amount = data['amount']
    callbackInfo = data['callbackInfo']
    cpOrderId = data['cpOrderId']
    creator = data['creator']
    failedDesc = data['failedDesc']
    gameId = data['gameId']
    orderId = data['orderId']
    orderStatus = data['orderStatus']
    payWay = data['payWay']
    base_str = "accountId=%samount=%scallbackInfo=%scpOrderId=%screator=%sfailedDesc=%sgameId=%sorderId=%sorderStatus=%spayWay=%s" % \
               (accountId,amount,callbackInfo,cpOrderId,creator,failedDesc,gameId,orderId,orderStatus,payWay)
    base_str += API_KEY
    logger.debug('uc base_str:%s', base_str)
    count_sign = hashlib.md5(base_str).hexdigest()
    logger.debug('uc count_sign:%s', count_sign)
    if count_sign == sign:
        return True
    else:
        return False

