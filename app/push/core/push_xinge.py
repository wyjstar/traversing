# -*- coding:utf-8 -*-
"""
Created on 2015-7-3
@author: hack
"""
import xinge
from gfirefly.server.logobj import logger


ACCESS_ID = 2100129370
ACCESS_KEY = 'c4c924896eb67aef87ec7421571ada28'


def push_by_token(token, message, title='hello', sound='default', badge=1):
    result = xinge.PushTokenAndroid(ACCESS_ID, ACCESS_KEY,
                                    title, message, token)
    logger.info('xinge push:%s', result)
