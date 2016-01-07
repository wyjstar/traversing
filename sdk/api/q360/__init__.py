# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import urllib2

if __name__ != '__main__':
    from gfirefly.server.logobj import logger

S360_URL = 'https://openapi.360.cn/user/me.json?'


def verify_login(token):
    url = '%saccess_token=%s&fields=id,name,avatar,sex,area' % (S360_URL,
                                                                token)
    logger.debug('360 url:%s', url)
    response = eval(urllib2.urlopen(url).read())
    return response


def recharge_verify():
    return True
