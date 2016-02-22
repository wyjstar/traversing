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


@webserviceHandle('/vivopay', methods=['post', 'get'])
def recharge_vivo_response():
    logger.debug('vivo recharge:%s', request.form)

    if request.form['respCode'] != '200' or request.form[
            'tradeStatus'] != '0000':
        logger.error('failed!! %s', request.form)
        return json.dumps(dict(respCode=120014))

    product_per_price = request.form['orderAmount']
    cp_order_id = request.form['cpOrderNumber']
    product_id = request.form['extInfo']

    player_id = int(cp_order_id.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return json.dumps(dict(code=120014, message='', value='', redirect=''))

    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.vivo_recharge_remote(oldvcharacter.dynamic_id,
                                             product_id, product_per_price,
                                             cp_order_id, True)
    if result is True:
        logger.debug('response:success')
        return json.dumps(dict(respCode=200))

    logger.debug('response:failed')
    return json.dumps(dict(respCode=120014))
