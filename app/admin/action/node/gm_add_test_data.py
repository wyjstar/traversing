# -*- coding:utf-8 -*-
"""
created by sphinx on 
"""
import json
from gfirefly.server.globalobject import webserviceHandle
from flask import request
from app.admin.action.root.netforwarding import push_object, rpc_object
from gfirefly.server.logobj import logger
import cPickle


@webserviceHandle('/gmtestdata:name')
def gm_add_test_data(account_name='hello world'):
    # account_name = request.args.get('name')
    return account_name


@webserviceHandle('/gm_get')
def gm_login():
    account_name = request.args.get('name')
    account_pwd = request.args.get('pwd')
    print account_name, account_pwd, 'aaaaaaaaaaaaaaa'
    push_object(account_name)

    return json.dumps(dict([(account_name, account_pwd), (1, account_pwd)]))


@webserviceHandle('/gm_post', methods=['post'])
def gm_post_test():
    response = {}
    command = request.form['command']
    logger.info('gm2admin,target:%s', command)
    res = rpc_object(command, cPickle.dumps(request.form))

    res = cPickle.loads(res)
    response["result"] = res.get('result')
    if res.get('data'):
        response["data"] = res.get('data')

    return json.dumps(response)