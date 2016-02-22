# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from flask import request
from gfirefly.server.logobj import logger
from sdk.api.uc import check_sign
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager


@webserviceHandle('/ucpay', methods=['post', 'get'])
def recharge_uc_response():
    logger.debug('uc recharge:%s', request.json)
    # 验证签名
    data = request.json['data']
    sign = request.json['sign']
    check_res = check_sign(data, sign)
    logger.debug('uc check_res:%s', check_res)
    # 验签失败
    if not check_res:
        return "FAILURE"
    # 发货
    cpOrderId = data['cpOrderId']
    orderId = data['callbackInfo']
    player_id = int(cpOrderId.split('_')[0])
    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        return "FAILURE"
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.uc_recharge_remote(
        oldvcharacter.dynamic_id, orderId, cpOrderId, True)
    logger.debug('uc result:%s', result)
    if not result:
        return "FAILURE"

    return "SUCCESS"
