# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
from gfirefly.server.globalobject import webserviceHandle
from flask import request


@webserviceHandle('/gmtestdata')
def gm_add_test_data():
    account_name = request.args.get('name')

    return account_name
