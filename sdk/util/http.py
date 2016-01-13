# coding: utf-8
# Created on 2013-8-28
# Author: jiang

import json
import urllib2
import time


post_json_headers = {"Content-type": "application/json", "Accept": "text/plain"}

class HttpRequest(object):
    """
    HTTP请求类
    """

    def __init__(self, log=None):
        """
        """
        self.log = log

    def _msg(self, content):
        """
        打印正常日志
        """
        if self.log:
            msg = getattr(self.log, 'msg', None)
            assert msg, "unimplemented method: log.msg"
            msg(content)


    def request(self, url, data=None, cookie=None, json_type=False, ext_header={}, get_json=True, method='post'):
        """
        请求数据

        Example:
            request('http://10.123.11.2:80/v3/pay_m', data={'key':10001})
        """
        print "======",data, url
        response = {}
        log_response = {}
        if method.lower() == 'post':
            dest_url = url
        elif method.lower() == 'get':
            if data:
                dest_url = '%s?%s' % (url, data)
            else:
                dest_url = url
        req = urllib2.Request(dest_url)
        if cookie:
            req.add_header('Cookie', cookie)
        if json_type:
            ext_header = post_json_headers
        for k, v in ext_header.items():
            req.add_header(k, v)
        try:
            if method.lower() == 'post':
                result = urllib2.urlopen(req, data = data)
            elif method.lower() == 'get':
                result = urllib2.urlopen(req)
            else:
                raise TypeError, 'method invalid:%s' % method

            #result = urllib2.urlopen(req, data=data, timeout=3)
            response = result.read()
            log_response = response
            if get_json:
                response = json.loads(response)
        except:
            self.log.exception()
        finally:
            self._msg('%s, %s, %s' %
                           (url, data, log_response))
        return response

if __name__ == "__main__":
    from sdk.util import logger
    log = logger.new_log('TxApi')
    http = HttpRequest(log)
    res = http.request("http://www.baidu.com", get_json=False)
