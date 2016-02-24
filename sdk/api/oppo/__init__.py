# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import base64
import urllib
import urllib2
import hashlib
import hmac
from Crypto.Signature import PKCS1_v1_5 as pk
from Crypto.Hash import SHA
from gfirefly.server.logobj import logger
from sdk.func import xtime
from sdk.func import xrand

QUERY_URL = "http://i.open.game.oppomobile.com/gameopen/user/fileIdInfo"
APP_KEY = "1578jpGKtgU88oo0OG0ggS0G0"
APP_SECRET = 'faD46f86AF7D6d7c61E2a08cd9808F4A'
PAY_PUBLIC_KEY = 'MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmreYIkPwVovKR8rLHWlFVw7YDfm9uQOJKL89Smt6ypXGVdrAKKl0wNYc3/jecAoPi2ylChfa2iRu5gunJyNmpWZzlCNRIau55fxGW0XEu553IiprOZcaw5OuYGlf60ga8QT6qToP0/dpiL/ZbmNUO9kUhosIjEu22uFgR+5cYyQIDAQAB'


def request_url(url, header={}):
    """
    请求url
    """
    req = urllib2.Request(url)
    for k, v in header.items():
        req.add_header(k, v)
    response = None
    try:
        result = urllib2.urlopen(req)
        response = result.read()
    except Exception, e:
        logger.error(e)
    return response


def verify_login(token, ssoid):
    """
    登录校验
    """
    parameters = {'fileId': ssoid, 'token': token}
    url = QUERY_URL + '?' + urllib.urlencode(parameters)
    oauthTimestamp = xtime.timestamp(1000)
    oauthNonce = xtime.timestamp() + xrand.randomint(0, 9)
    base_str = urllib.urlencode({'oauthConsumerKey': APP_KEY}) + '&'
    base_str += urllib.urlencode({'oauthToken': token}) + '&'
    base_str += urllib.urlencode({'oauthSignatureMethod': 'HMAC-SHA1'}) + '&'
    base_str += urllib.urlencode({'oauthTimestamp': oauthTimestamp}) + '&'
    base_str += urllib.urlencode({'oauthNonce': oauthNonce}) + '&'
    base_str += urllib.urlencode({'oauthVersion': '1.0'}) + '&'
    oauthSignature = APP_SECRET + '&'
    sign = hmac.new(oauthSignature, base_str,
                    hashlib.sha1).digest().encode('base64').rstrip()

    sign = urllib.urlencode({'': sign})[1:]
    result = request_url(url, {'param': base_str, 'oauthSignature': sign})
    if result:
        js = json.loads(result)
        if js["resultCode"] == '200' and js["ssoid"] == ssoid:
            return js

    logger.error(result)
    return None


def check_sign(rdata):
    """
    验证签名
    """
    signn = base64.b64decode(rdata.pop('sign'))
    signdata = sort(rdata)
    verifier = pk.new(PAY_PUBLIC_KEY)
    if verifier.verify(SHA.new(signdata), signn):
        return True
    else:
        return False


def sort(mes):
    """
    取出key值,按照字母排序后将value拼接起来
    返回字符串
    """
    _par = []

    keys = mes.keys()
    keys.sort()
    for v in keys:
        _par.append(str(mes[v]))
    sep = ''
    message = sep.join(_par)
    return message
