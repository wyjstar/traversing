# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import base64
import hashlib
import json
from flask import request
from gfirefly.server.logobj import logger

from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager

appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"


@webserviceHandle('/baidupay', methods=['post', 'get'])
def recharge_baidu_response():
    resultCode = "1"
    resultMsg = "成功"

    logger.debug('baidu recharge:%s', request.form)

    appid = request.form['AppID']
    orderSerial = request.form['OrderSerial']
    cooperatorOrderSerial = request.form['CooperatorOrderSerial']
    content = request.form['Content']
    sign = request.form['Sign']
    # content = u'eyJVSUQiOjIxMDY0MTQ5MDEsIk1lcmNoYW5kaXNlTmFtZSI6IjYwIiwiT3JkZXJNb25leSI6IjAuMDEiLCJTdGFydERhdGVUaW1lIjoiMjAxNi0wMS0xMSAxOTowMjo0MCIsIkJhbmtEYXRlVGltZSI6IjIwMTYtMDEtMTEgMTk6MDI6NTMiLCJPcmRlclN0YXR1cyI6MSwiU3RhdHVzTXNnIjoi5oiQ5YqfIiwiRXh0SW5mbyI6IiIsIlZvdWNoZXJNb25leSI6MH0='
    # cooperatorOrderSerial = u'10000_1452510158'
    # orderSerial = u'5ee0f373af4b5c03_01001_2016011119_000000'
    # sign = u'962831d61d2879f54583799c5a0009e1'

    # 验证签名
    if sign != hashlib.md5(appid + orderSerial + cooperatorOrderSerial +
                           content + secretkey).hexdigest():
        resultCode = "10001"
        resultMsg = "Sign无效"
        print 'error:', sign, 'md5:', hashlib.md5(
            appid + orderSerial + cooperatorOrderSerial + content +
            secretkey).hexdigest()
        return resultMsg

    # base64解码
    content = base64.b64decode(content)
    # json解析
    js = json.loads(content)
    logger.debug('content:', js)

    # print js["UID"]
    # print js["MerchandiseName"]
    fee = float(js["OrderMoney"])
    # print js["StartDateTime"]
    # print js["BankDateTime"]
    # print js["OrderStatus"]
    # print js["StatusMsg"]
    product_id = js["ExtInfo"]
    # print js["VoucherMoney"]
    # print resultMsg
    response = "{\"AppID\":" + appid + ",\"ResultCode\":" + resultCode + \
               ",\"ResultMsg\":\"" + resultMsg + "\",\"Sign\":\"" + \
               hashlib.md5(appid + resultCode + secretkey).hexdigest() + \
               "\",\"Content\":\"\"}"
    print response

    player_id = int(cooperatorOrderSerial.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return 'failed'
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.baidu_recharge_remote(oldvcharacter.dynamic_id,
                                              product_id, fee, True)
    if result:
        return response

    return 'failed'
