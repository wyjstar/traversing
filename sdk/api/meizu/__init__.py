# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import urllib2
from gfirefly.server.logobj import logger

queryUrl = "https://open-api.flyme.cn/v2/check?"


def verify_login(token):
    url = '%saccess_token=%s' % (queryUrl, token)
    logger.debug('meizu url:%s', url)
    response = eval(urllib2.urlopen(url).read())
    return response
