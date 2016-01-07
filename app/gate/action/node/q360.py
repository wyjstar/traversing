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


@webserviceHandle('/q360pay', methods=['post', 'get'])
def recharge_response():
    # order_id=1211090012345678901&
    # app_key=1234567890abcdefghijklmnopqrstuv&
    # product_id=p1&
    # amount=101&
    # app_uid=123456789&
    # app_ext1=XXX201211091985&
    # app_order_id=order1234&
    # user_id=987654321&
    # sign_type=md5&
    # gateway_flag=success&
    # sign=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&
    # sign_return=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    product_id = request.form.get('product_id')
    # order_id = request.form.get('order_id')
    # app_key = request.form.get('app_key')
    # amount = request.form.get('amount')
    # app_uid = request.form.get('app_uid')
    # app_ext1 = request.FORM.GET('app_ext1')
    # app_order_id = request.form.get('app_order_id')
    # user_id = request.form.get('user_id')
    # sign_type = request.form.get('sign_type')
    # gateway_flag = request.form.get('gateway_flag')
    # sign = request.form.get('sign')
    # sign_return = request.form.get('sign_return')

    logger.debug('360 recharge:%s', request.form)

    result, fee = recharge_verify()

    player_id = int(product_id)

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return 'failed'
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.q360_recharge_remote(oldvcharacter.dynamic_id,
                                             product_id, True)
    if result:
        return 'success'

    return 'failed'
