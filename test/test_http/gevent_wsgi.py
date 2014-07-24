# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午11:49.
"""

from gevent import wsgi


def hello_world(environ, start_response):

    print start_response
    print environ

    status = '200 OK'
    res = "hello world"
    response_headers = [('Content-type', 'text/plain')]
    start_response(status, response_headers)
    return [res]

wsgi.WSGIServer(('', 8001), hello_world, log=None).serve_forever()