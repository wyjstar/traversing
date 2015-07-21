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


@webserviceHandle('/')
def recharge_response():
    post_sign = request.args.get('post_sign')
    post_notify_data = request.args.get('post_notify_data')
    post_orderid = request.args.get('post_orderid')
    post_dealseq = request.args.get('post_dealseq')
    post_uid = request.args.get('post_uid')
    post_subject = request.args.get('post_subject')
    post_v = request.args.get('post_v')

    logger.debug('kuaiyong recharge:%s', request.args)

    result = recharge_verify(post_sign,
                             post_notify_data,
                             post_orderid,
                             post_dealseq,
                             post_uid,
                             post_subject,
                             post_v)

    logger.debug('kuaiyong recharge:%s', result)
    if result:
        player_id = post_dealseq

        oldvcharacter = VCharacterManager().get_by_id(player_id)
        if not oldvcharacter:
            return
        child_node = GlobalObject().child(oldvcharacter.node)
        result = child_node.kuaiyong_recharge_remote(post_subject)
