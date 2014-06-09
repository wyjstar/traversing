# -*- coding:utf-8 -*-
"""
created by server on 14-6-9下午6:14.
"""

def application(env, start_response):
    start_response('200 OK', [('Content-Type','text/html')])
    return "Hello World"