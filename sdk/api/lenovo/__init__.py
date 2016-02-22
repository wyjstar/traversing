# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import urllib
import xml.dom.minidom
from gfirefly.server.logobj import logger

lenovo_URL = 'http://passport.lenovo.com/interserver/authen/1.2/getaccountid'

lenovo_realm = '1601251703799.app.ln'

# Open AppId是：1601251703799.app.ln
# Channel_ID :lenovo


def verify_login(token):
    url = '%s?lpsust=%s&realm=%s' % (lenovo_URL, token, lenovo_realm)
    logger.debug('lenovo url:%s', url)
    response = urllib.urlopen(url).read()
    logger.debug('lenovo return:%s', response)
    xmldoc = xml.dom.minidom.parseString(response)
    accountid = xmldoc.getElementsByTagName('AccountID')
    if not accountid:
        return ''

    return accountid[0].childNodes[0].nodeValue
