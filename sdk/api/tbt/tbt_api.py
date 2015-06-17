# coding: utf-8
from sdk.util.http import HttpRequest
from sdk.util import logger_sdk

def verify_login(session, appid):
    """
    登陆校验
    """
    log = logger_sdk.new_log('TBT')
    http = HttpRequest(log)
    url = "http://tgi.tongbu.com/api/LoginCheck.ashx?session=%s&appid=%s" % (session, appid)
    return http.request(url, method='get')
