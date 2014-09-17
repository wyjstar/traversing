#-*- coding:utf-8 -*-
"""
created by server on 14-5-26下午12:14.
"""
from flask import request
from gfirefly.server.globalobject import webserviceHandle


@webserviceHandle('/test')
def test():
    # request.args.get

    print 'test'

    return 'test'


@webserviceHandle('/opera')
def opera():
    print 111111