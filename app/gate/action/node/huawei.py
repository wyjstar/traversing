# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import json
from flask import request
from gfirefly.server.logobj import logger

from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager

appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

# ('userName', u'890086000001005734')
# ('orderId', u'HWceshizhifu20160125')
# ('orderTime', u'2016-01-25 07:46:41')
# ('spending', u'0.01')
# ('accessMode', u'0')
# ('payType', u'4')
# ('productName', u'1\u5143\u5b9d')
# ('amount', u'0.01')
# ('tradeTime', u'2016-01-25 07:46:41')
# ('result', u'0')
# ('notifyTime', u'1453708001271')
# ('sign', u'ZCe1TO4TvYuHFPSv5VcTPy3VxaT77ET8xm8ZdARLPgqrLLC1LfHO25UgcKm/gFuTGpoGKmj1NV6SIKpnFiTF5A==')
# ('requestId', u'HWceshizhifu20160125')


@webserviceHandle('/huaweipay', methods=['post', 'get'])
def recharge_huawei_response():
    logger.debug('huawei recharge:%s', request.form)

    # userName = request.form['userName']
    # orderId = request.form['orderId']
    # orderTime = request.form['orderTime']
    # spending = request.form['spending']
    # accessMode = request.form['accessMode']
    # payType = request.form['payType']
    # productName = request.form['productName']
    amount = request.form['amount']
    # tradeTime = request.form['tradeTime']
    # result = request.form['result']
    # notifyTime = request.form['notifyTime']
    # sign = request.form['sign']
    requestId = request.form['requestId']
    extReserved = request.form['extReserved']

    # 验证签名
    # if sign != hashlib.md5(appid + orderSerial + cooperatorOrderSerial +
    #                        content + secretkey).hexdigest():
    #     resultCode = "10001"
    #     resultMsg = "Sign无效"
    #     print 'error:', sign, 'md5:', hashlib.md5(
    #         appid + orderSerial + cooperatorOrderSerial + content +
    #         secretkey).hexdigest()
    #     return resultMsg

    player_id = int(requestId.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return json.dumps(dict(result=3))

    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.huawei_recharge_remote(
        oldvcharacter.dynamic_id, extReserved, amount, requestId, True)
    if result is True:
        logger.debug('response:success')
        return json.dumps(dict(result=0))

    logger.debug('response:failed')
    return json.dumps(dict(result=3))
