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
