# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import time
import urllib2
import hashlib

from gfirefly.server.logobj import logger

queryUrl = "https://api.game.meizu.com/game/security/checksession"

appid = '2912223'
AppSecret = 'JjGHJ59jhh89OAwX77aUalz3Fqe5Ovcn'


def postUrl(url, data):
    req = urllib2.Request(url)
    # data = urllib.urlencode(data)
    # enable cookie
    opener = urllib2.build_opener(urllib2.HTTPCookieProcessor())
    response = opener.open(req, data)
    return response.read()


def verify_login(uid, token):
    timestamp = int(time.time() * 1000)
    postdata = 'app_id=%s&session_id=%s&ts=%s&uid=%s' % (appid, token,
                                                         timestamp, uid)
    sign = hashlib.md5(postdata + ':' + AppSecret).hexdigest()
    postdata += '&sign_type=md5&sign=' + sign

    logger.debug('meizu postdata:%s', postdata)
    result = eval(postUrl(queryUrl, postdata))

    return result['code'] == 200
