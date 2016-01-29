# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import urllib
import urllib2

# 应用开发者appid
appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

queryUrl = "https://usrsys.inner.bbk.com/auth/user/info"


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


def recharge_verify():
    return True
