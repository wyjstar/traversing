# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import time
import json
import urllib
import urllib2
from gfirefly.server.logobj import logger

# 应用开发者appid
appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

queryUrl = "https://api.vmall.com/rest.php"


def postUrl(url, data):
    req = urllib2.Request(url)
    data = urllib.urlencode(data)
    # enable cookie
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    response = opener.open(req, data)
    return response.read()


def verify_login(token):
    postdata = {'nsp_svc': "OpenUP.User.getInfo",
                'nsp_ts': int(time.time()),
                'access_token': token}
    logger.debug('postdata:%s', postdata)
    result = postUrl(queryUrl, postdata)
    logger.debug('result:%s', result)
    return json.loads(result)


def recharge_verify():
    return True
