# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import base64
import json
from flask import request
from gfirefly.server.logobj import logger
from sdk.api.uc import check_sign
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager


@webserviceHandle('/ucpay', methods=['post', 'get'])
def recharge_oppo_response():
    logger.debug('uc recharge:%s', request.form)
    # 验证签名
    data = request.form['data']
    sign = request.form['sign']
    check_res = check_sign(data, sign)
    # 验签失败
    if not check_res:
        return "FAILURE"
    # 发货
    cpOrderId = data['cpOrderId']
    orderId = data['orderId']
    player_id = int(cpOrderId.split('_')[0])
    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        return "result=FAIL&resultMsg=玩家未在线"
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.uc_recharge_remote(
        oldvcharacter.dynamic_id, orderId, cpOrderId, True)
    if not result:
        return "result=FAIL&resultMsg=发货失败"

    return "result=OK"
