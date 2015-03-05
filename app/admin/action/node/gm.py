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
    res = {}
    admin_command = ['update_excel']
    if request.args:
        t_dict = request.args
    else:
        t_dict = request.form
    logger.info('gm2admin,command:%s', t_dict['command'])
    if t_dict['command'] in admin_command:
        com = t_dict['command'] + "(t_dict)"
        res = eval(com)
        # res = {"result": True}
    else:
        res = remote_gate.from_admin_rpc_remote(cPickle.dumps(t_dict))
        res = cPickle.loads(res)
    response["result"] = res.get('result')
    if res.get('data'):
        response["data"] = res.get('data')

    return json.dumps(response)


@webserviceHandle('/gm2', methods=['post', 'get'])
def gm2():
    response = {}
    if request.args:
        args = request.args
    else:
        args = request.form
    data = dict((key, args.getlist(key)[0]) for key in args.keys())
    logger.debug("data:%s", data)
    key = data.get('command')
    res = remote_gate.push_message_remote(key, int(data.get('uid')), cPickle.dumps(data))

    response["result"] = str(res)
    return json.dumps(response)


def update_excel(args):
    print args['command'], '**********************************************'
    return {"result":True}
