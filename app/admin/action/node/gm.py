# -*- coding:utf-8 -*-
"""
created by sphinx on
"""
import json
from gfirefly.server.globalobject import webserviceHandle
from flask import request
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import GlobalObject
import cPickle


remote_gate = GlobalObject().remote['gate']


@webserviceHandle('/gmtestdata:name')
def gm_add_test_data(account_name='hello world'):
    # account_name = request.args.get('name')
    return account_name


@webserviceHandle('/gm', methods=['post', 'get'])
def gm():
    response = {}
    if request.args:
        t_dict = request.args
    else:
        t_dict = request.form
    logger.info('gm2admin,command:%s', t_dict['command'])
    res = remote_gate.from_admin_rpc_remote(cPickle.dumps(t_dict))

    res = cPickle.loads(res)
    response["result"] = res.get('result')
    if res.get('data'):
        response["data"] = res.get('data')

    return json.dumps(response)
