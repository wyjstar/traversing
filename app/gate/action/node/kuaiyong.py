# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from flask import request
from gfirefly.server.logobj import logger
from sdk.api.kuaiyong import recharge_verify

from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import webserviceHandle
from app.gate.core.virtual_character_manager import VCharacterManager
import json

AppId = GlobalObject().allconfig["xmsdk"]["AppId"]
AppKey = GlobalObject().allconfig["xmsdk"]["AppKey"]
AppSecret = GlobalObject().allconfig["xmsdk"]["AppSecret"]
VerifySession_URL = GlobalObject().allconfig["xmsdk"]["VerifySession_URL"]


@webserviceHandle('/kypay', methods=['post', 'get'])
def recharge_response():
    post_sign = request.form.get('sign')
    post_notify_data = request.form.get('notify_data')
    post_orderid = request.form.get('orderid')
    post_dealseq = request.form.get('dealseq')
    post_uid = request.form.get('uid')
    post_subject = request.form.get('subject')
    post_v = request.form.get('v')

    logger.debug('kuaiyong recharge:%s', request.form)

    result, fee = recharge_verify(post_sign,
                                  post_notify_data,
                                  post_orderid,
                                  post_dealseq,
                                  post_uid,
                                  post_subject,
                                  post_v)

    if result:
        player_id = int(post_dealseq.split('_')[0])

        oldvcharacter = VCharacterManager().get_by_id(player_id)
        if not oldvcharacter:
            logger.error('fail get player node:%s', player_id)
            return 'failed'
        child_node = GlobalObject().child(oldvcharacter.node)
        result = child_node.kuaiyong_recharge_remote(oldvcharacter.dynamic_id,
                                                     post_subject, fee,
                                                     True)
        if result:
            return 'success'

    return 'failed'

@webserviceHandle('/xmpay', methods=['post', 'get'])
def xm_recharge_response():
    logger.debug('xiaomi recharge:%s', request.args)
    appId = request.args.get('appId')
    cpOrderId = request.args.get('cpOrderId')
    cpUserInfo = request.args.get('cpUserInfo')
    uid = request.args.get('uid')
    orderId = request.args.get('orderId')
    orderStatus = request.args.get('orderStatus')
    payFee = request.args.get('payFee')
    productCode = request.args.get('productCode')
    productName = request.args.get('productName')
    productCount = request.args.get('productCount')
    payTime = request.args.get('payTime')
    orderConsumeType = request.args.get('orderConsumeType')
    signature = request.args.get('signature')


    if int(AppId) != int(appId):
        logger.error('appId diff:%s get %s' % (AppId, appId))
        return return_data(1515)

    if orderStatus == "TRADE_SUCCESS":
        player_id = int(cpOrderId.split('_')[0])

        oldvcharacter = VCharacterManager().get_by_id(player_id)
        if not oldvcharacter:
            logger.error('fail get player node:%s', player_id)
            return ''
        child_node = GlobalObject().child(oldvcharacter.node)
        result = child_node.xiaomi_recharge_remote(oldvcharacter.dynamic_id,
                                                     productCode, payFee, cpOrderId,
                                                     True)
        return return_data(result)

    return return_data(1525)

def return_data(code):
    return json.dumps({'errcode': code})
