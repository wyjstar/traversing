# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import time
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


def recharge_verify():
    return True
