# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from flask import request
from gfirefly.server.logobj import logger

from gfirefly.server.globalobject import webserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager


@webserviceHandle('/lenovopay', methods=['post', 'get'])
def recharge_lenovo_response():
    logger.debug('lenovo recharge:%s', request.form)
    data = eval(request.form['transdata'])

    product_per_price = data['money']
    cp_order_id = data['exorderno']
    product_id = data['cpprivate']

    player_id = int(cp_order_id.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return 'FAILURE'

    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.lenovo_recharge_remote(oldvcharacter.dynamic_id,
                                               product_id, product_per_price,
                                               cp_order_id, True)
    if result is True:
        logger.debug('response:success')
        return 'SUCCESS'

    logger.debug('response:failed')
    return 'FAILURE'
