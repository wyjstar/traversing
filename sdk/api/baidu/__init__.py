# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
import base64
import urllib
import urllib2
import hashlib
from gfirefly.server.logobj import logger

# 应用开发者appid
appid = "7595234"
# 应用开发者secretkey
secretkey = "pcSugeUWbdripDyzLSGGhZjuG2VX26BO"

queryUrl = "http://querysdkapi.91.com/CPLoginStateQuery.ashx"


def postUrl(url, data):
    req = urllib2.Request(url)
    data = urllib.urlencode(data)
    # enable cookie
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    response = opener.open(req, data)
    return response.read()


def verify_login(token):
    sign = hashlib.md5(appid + token + secretkey).hexdigest()
    postdata = {'AppID': appid, 'AccessToken': token, 'Sign': sign}
    result = postUrl(queryUrl, postdata)
    js = json.loads(result)

    if js["ResultCode"] == 1 and js["Sign"] == hashlib.md5(appid + str(js[
            "ResultCode"]) + urllib.unquote(js[
                "Content"]) + secretkey).hexdigest() and js["Content"] != "":
        # Content参数Urldecode
        Content = urllib.unquote(js["Content"])
        # Base64解码
        content = base64.b64decode(Content)
        print content
        # 根据获取的信息，执行业务处理

        # json解析
        item = json.loads(content)
        print item["UID"]
        print item
        return item

    logger.error(result)
    return None


def sign_make(sign, appid, orderSerial, cooperatorOrderSerial, content):
    # 验证签名
    return hashlib.md5(appid + orderSerial + cooperatorOrderSerial + content +
                       secretkey).hexdigest()


def response_sign(resultCode):
    return hashlib.md5(appid + resultCode + secretkey).hexdigest()
