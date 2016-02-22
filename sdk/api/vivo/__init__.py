# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import time
import json
import urllib
import urllib2
from hashlib import md5
from gfirefly.server.logobj import logger

queryUrl = "https://usrsys.inner.bbk.com/auth/user/info"
orderUrl = 'https://pay.vivo.com.cn/vcoin/trade'
channel = 'vivo'

CP_ID = 20160128182223262510
CP_KEY = md5('aa9bed3001beb75a710337ade4c5d9a4').hexdigest()
APP_ID = '8c15fa2a6139d712aefeb79cc2e9d275'


def postUrl(url, data):
    req = urllib2.Request(url)
    data = urllib.urlencode(data)
    # enable cookie
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    response = opener.open(req, data)
    return response.read()


def verify_login(token):
    postdata = {'access_token': token}
    result = postUrl(queryUrl, postdata)
    js = json.loads(result)
    print js
    return js


def generat_orderid(cpOrderid, callback_url, amount, desc, orderTitle,
                    extinfo):
    _time = time.strftime("%Y%m%d%H%M%S")
    data = {}
    data['version'] = '1.0.0'
    data['signMethod'] = 'MD5'
    data['signature'] = ''
    data['cpId'] = CP_ID
    data['appId'] = APP_ID
    data['cpOrderNumber'] = cpOrderid
    data['notifyUrl'] = callback_url
    data['orderTime'] = str(_time)
    data['orderAmount'] = amount
    data['orderTitle'] = orderTitle
    data['orderDesc'] = desc
    data['extInfo'] = extinfo
    sign_data = 'appId=%s' % APP_ID
    sign_data += '&cpId=%s' % CP_ID
    sign_data += '&cpOrderNumber=%s' % cpOrderid
    sign_data += '&extInfo=%s' % extinfo
    sign_data += '&notifyUrl=%s' % callback_url
    sign_data += '&orderAmount=%s' % amount
    sign_data += '&orderDesc=%s' % desc
    sign_data += '&orderTime=%s' % _time
    sign_data += '&orderTitle=%s' % orderTitle
    sign_data += '&version=1.0.0'
    sign_data += '&' + CP_KEY
    # print sign_data
    data['signature'] = md5(sign_data).hexdigest()
    # print data

    result = eval(postUrl(orderUrl, data))
    logger.debug(result)
    if result['respCode'] != '200':
        logger.error(result)
        return None, None
    return result['orderNumber'], result['accessKey']


def recharge_verify():
    return True
