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

appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

# ('uid', u'114498471')
# ('order_id', u'16012822003652832')
# ('app_id', u'2912223')
# ('sign', u'a6d2d28cec2726ad5fee716c818256ec')
# ('buy_amount', u'1')
# ('create_time', u'1453965477737')
# ('pay_time', u'1453965487365')
# ('trade_status', u'3')
# ('partner_id', u'114456735')
# ('product_id', u'lord_gold_60')
# ('pay_type', u'0')
# ('total_price', u'0.01')
# ('product_per_price', u'0.01')
# ('product_unit', u'')
# ('cp_order_id', u'10012_1453965475')
# ('user_info', u'')
# ('sign_type', u'MD5')
# ('notify_time', u'2016-01-28 16:45:05')
# ('notify_id', u'1453970705871')


@webserviceHandle('/meizupay', methods=['post', 'get'])
def recharge_meizu_response():
    logger.debug('meizu recharge:%s', request.form)

    # uid = request.form['uid']
    # order_id = request.form['order_id']
    # app_id = request.form['app_id']
    # sign = request.form['sign']
    # buy_amount = request.form['buy_amount']
    # create_time = request.form['create_time']
    # pay_time = request.form['pay_time']
    # trade_status = request.form['trade_status']
    # partner_id = request.form['partner_id']
    product_id = request.form['product_id']
    # pay_type = request.form['pay_type']
    # total_price = request.form['total_price']
    product_per_price = request.form['product_per_price']
    # product_unit = request.form['product_unit']
    cp_order_id = request.form['cp_order_id']
    # user_info = request.form['user_info']
    # sign_type = request.form['sign_type']
    # notify_time = request.form['notify_time']
    # notify_id = request.form['notify_id']

    player_id = int(cp_order_id.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return json.dumps(dict(code=120014, message='', value='', redirect=''))

    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.meizu_recharge_remote(oldvcharacter.dynamic_id,
                                              product_id, product_per_price,
                                              cp_order_id, True)
    if result is True:
        logger.debug('response:success')
        return json.dumps(dict(code=200, message='', value='', redirect=''))

    logger.debug('response:failed')
    return json.dumps(dict(code=120014, message='', value='', redirect=''))
