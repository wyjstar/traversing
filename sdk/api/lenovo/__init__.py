# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import urllib2
from gfirefly.server.logobj import logger

lenovo_URL = 'http://passport.lenovo.com/interserver/authen/1.2/getaccountid'

lenovo_realm = 'com.mobartsgame.transfer.lenovo'

# Open AppId是：1601251703799.app.ln
# Channel_ID :lenovo


def verify_login(token):
    url = '%slpsust=%s&realm=%s' % (lenovo_URL, token, lenovo_realm)
    logger.debug('360 url:%s', url)
    response = eval(urllib2.urlopen(url).read())
    return response

# def recharge_verify():
#     return True
