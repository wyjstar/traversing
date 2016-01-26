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


@webserviceHandle('/meizupay', methods=['post', 'get'])
def recharge_meizu_response():
    logger.debug('meizu recharge:%s', request.form)

    amount = request.form['amount']
    requestId = request.form['requestId']
    extReserved = request.form['extReserved']

    player_id = int(requestId.split('_')[0])

    oldvcharacter = VCharacterManager().get_by_id(player_id)
    if not oldvcharacter:
        logger.error('fail get player node:%s', player_id)
        return json.dumps(dict(result=3))

    child_node = GlobalObject().child(oldvcharacter.node)
    result = child_node.meizu_recharge_remote(
        oldvcharacter.dynamic_id, extReserved, amount, requestId, True)
    if result is True:
        logger.debug('response:success')
        return json.dumps(dict(result=0))

    logger.debug('response:failed')
    return json.dumps(dict(result=3))
