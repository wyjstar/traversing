# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import json
from gfirefly.dbentrust import util
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.dbentrust.dbpool import dbpool
from flask import request
import time
import uuid
from gfirefly.server.logobj import logger

account_login_cache = []
USER_TABLE_NAME = 'tb_user'


def get_uuid():
    return uuid.uuid1().get_hex()


def __user_register(account_name='', account_password=''):
    # todo check account name password
    # sql_result = select_execute(USER_TABLE_NAME, dict(account_name=account_name))
    sql_result = util.GetOneRecordInfo(USER_TABLE_NAME, dict(account_name=account_name))
    if sql_result:
        return json.dumps(dict(result=False, message='account name is exist'))

    user_data = dict(id=get_uuid(),
                     account_name=account_name,
                     account_password=account_password,
                     last_login=0,
                     create_time=int(time.time()))

    insert_result = util.InsertIntoDB(USER_TABLE_NAME, user_data)
    if insert_result:
        return json.dumps(dict(result=True, passport=user_data.get('uuid')))
    return json.dumps(dict(result=False, message='error'))


@webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    logger.info('register name:%s pwd:%s', user_name, user_pwd)

    return __user_register(account_name=user_name, account_password=user_pwd)


def __user_login(account_name='', account_password=''):
    get_result = util.GetOneRecordInfo(USER_TABLE_NAME, dict(account_name=account_name,
                                                             account_password=account_password))
    logger.info(get_result)
    if get_result is None:
        return json.dumps(dict(result=False, message='account name or password error!'))

    if get_result['id'] not in account_login_cache:
        account_login_cache.append(get_result['id'])
    return json.dumps(dict(result=True, passport=get_result['id']))


@webserviceHandle('/login')
def user_login():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    logger.info('login name:%s, pwd:%s', user_name, user_pwd)
    return __user_login(account_name=user_name, account_password=user_pwd)


@webserviceHandle('/verify')
def user_verify():
    user_passport = request.args.get('passport')
    logger.info(account_login_cache)
    if user_passport not in account_login_cache:
        return str({'result': False})
    account_login_cache.remove(user_passport)
    return str({'result': True})


if __name__ == '__main__':
    dbconfig = {'host': '127.0.0.1',
                'user': 'test',
                'passwd': 'test',
                'db': 'db_traversing',
                'port': 8066,
                'charset': 'utf8'}

    dbpool.initPool(**dbconfig)
    # ddd = util.GetOneRecordInfo(USER_TABLE_NAME, dict(account_name='aaa'))
    user = dict(id=get_uuid(),
                account_name='ddd',
                account_password='111',
                last_login=0,
                create_time=int(time.time()))

    sql_result = util.InsertIntoDB(USER_TABLE_NAME, user)
    # print get_id()
    # threads = []
    # for _ in range(100):
    #     threads.append(gevent.spawn(get_id))
    # gevent.joinall(threads)
    # sql_result = select_execute(USER_TABLE_NAME, dict(account_name='eee'))
    user = dict(id='fdsfsfjkl',
                account_name='aaa',
                account_password='222',
                last_login=0,
                create_time=int(time.time()))
