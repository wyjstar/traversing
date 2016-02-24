# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from flask import request
from gfirefly.server.logobj import logger
from sdk.api.oppo import check_sign
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager


@webserviceHandle('/oppopay', methods=['post', 'get'])
def recharge_oppo_response():
    logger.debug('oppo recharge:%s', request.form)
    # 验证签名
    partnerOrder = request.form['partnerOrder']
    product_id = request.form['partnerOrder']
    data = {'notifyId': request.form['notifyId'],
            'partnerOrder': partnerOrder,
            'productName': request.form['productName'],
            'productDesc': request.form['productDesc'],
            'price': request.form['price'],
            'count': request.form['count'],
            'attach': request.form['attach'],
            'sign': request.form['sign']}
    check_res = check_sign(data)
    # 验签失败
    if not check_res:
        logger.error("result=FAIL&resultMsg=Sign无效")
        return "result=FAIL&resultMsg=Sign无效"
    # 发货
    player_id = int(partnerOrder.split('_')[0])
    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error("result=FAIL&resultMsg=玩家未在线")
        return "result=FAIL&resultMsg=玩家未在线"
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.oppo_recharge_remote(oldvcharacter.dynamic_id,
                                             product_id, partnerOrder, True)
    if not result:
        logger.error("result=FAIL&resultMsg=发货失败")
        return "result=FAIL&resultMsg=发货失败"

    return "result=OK"
