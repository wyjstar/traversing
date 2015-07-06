# -*- coding:utf-8 -*-
"""
Created on 2015-7-3
@author: hack
"""

from app.push.core.apns import APNs, Payload
from gfirefly.server.logobj import logger


apns_handler = APNs(use_sandbox=True, cert_file='push_dev.pem', enhanced=True)


def push_by_token(token, message, title='', sound='default', badge=1):
    payload = Payload(alert=message, sound='default', badge=1)
    apns_handler.gateway_server.send_notification(token, payload)
    logger.info('apns push:%s', message)
