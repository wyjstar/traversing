# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from flask import request
from gfirefly.server.logobj import logger

from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import webserviceHandle
from app.gate.core.virtual_character_manager import VCharacterManager

APPID = '202882301'
APPKEY = '7c4ad6edb7babaee8adf3e42b976fe97'
APPSECRET = 'b6878fa9d309c9f13cc3add6d5858d95'


@webserviceHandle('/q360pay', methods=['post', 'get'])
def recharge360_response():
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

    product_id = request.args.get('product_id')
    # order_id = request.args.get('order_id')
    app_key = request.args.get('app_key')
    # amount = request.args.get('amount')
    app_uid = request.args.get('app_uid')
    # app_ext1 = request.FORM.GET('app_ext1')
    app_order_id = request.args.get('app_order_id')
    # user_id = request.args.get('user_id')
    # sign_type = request.args.get('sign_type')
    # gateway_flag = request.args.get('gateway_flag')
    # sign = request.args.get('sign')
    # sign_return = request.args.get('sign_return')
    if APPKEY != app_key:
        logger.error('err appkey=%s-%s, appid=%s-%s', APPKEY, app_key, APPID,
                     app_uid)
        logger.error('360 recharge:%s', request.args)
        return 'failed'

    logger.debug('360 recharge:%s', request.args)

    player_id = int(app_order_id.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return 'failed'
    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.q360_recharge_remote(oldvcharacter.dynamic_id,
                                             product_id, app_order_id, True)
    if result:
        return 'ok'

    return 'failed'
