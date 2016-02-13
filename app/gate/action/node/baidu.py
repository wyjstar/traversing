# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import base64
import json
from flask import request
from gfirefly.server.logobj import logger
from sdk.api.baidu import sign_make
from sdk.api.baidu import response_sign

from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager


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

    # 验证签名
    sign_l = sign_make(sign, appid, orderSerial, cooperatorOrderSerial,
                       content)
    if sign != sign_l:
        resultCode = "10001"
        resultMsg = "Sign无效"
        logger.error('error:md5--%s  :  %s', sign, sign_l)
        return resultMsg

    # base64解码
    content = base64.b64decode(content)
    # json解析
    js = json.loads(content)
    logger.debug('content:', js)

    # print js["UID"]
    # print js["MerchandiseName"]
    fee = js["OrderMoney"]
    # print js["StartDateTime"]
    # print js["BankDateTime"]
    # print js["OrderStatus"]
    # print js["StatusMsg"]
    product_id = js["ExtInfo"]
    # print js["VoucherMoney"]
    # print resultMsg
    response = "{\"AppID\":" + appid + ",\"ResultCode\":" + resultCode + \
               ",\"ResultMsg\":\"" + resultMsg + "\",\"Sign\":\"" + \
               response_sign(resultCode) + "\",\"Content\":\"\"}"

    player_id = int(cooperatorOrderSerial.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return 'failed'
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.baidu_recharge_remote(
        oldvcharacter.dynamic_id, product_id, fee, cooperatorOrderSerial, True)
    if result is True:
        logger.debug('response:%s', response)
        return response

    logger.debug('response:failed')
    return 'failed'
