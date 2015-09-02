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
TOURIST_PWD = '_tourist_'

USER_TABLE_MAX = util.GetTableCount(USER_TABLE_NAME)


def get_uuid():
    return uuid.uuid1().get_hex()


def __user_register(account_name='', account_password='',
                    device_id='', is_tourist=True):
    # todo check account name password
    sql_result = util.GetOneRecordInfo(USER_TABLE_NAME,
                                       dict(account_name=account_name))
    if sql_result:
        return json.dumps(dict(result=False,
                               result_no=1,
                               message='account name is exist'))

    if is_tourist:
        global USER_TABLE_MAX
        USER_TABLE_MAX += 1
        account_name = 'tourist%s' % USER_TABLE_MAX
        account_password = TOURIST_PWD

    user_data = dict(id=get_uuid(),
                     account_name=account_name,
                     account_password=account_password,
                     device_id=device_id,
                     last_login=0,
                     create_time=int(time.time()))

    insert_result = util.InsertIntoDB(USER_TABLE_NAME, user_data)
    if insert_result:
        return json.dumps(dict(result=True,
                               result_no=0,
                               account_name=account_name,
                               account_password=account_password,
                               passport=user_data.get('uuid')))
    return json.dumps(dict(result=False, result_no=-1, message='error'))


@webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    device_id = request.args.get('deviceid', '')
    is_tourist = 'tourist' in request.args
    logger.info('register name:%s pwd:%s %s', user_name, user_pwd, is_tourist)

    if not user_name.isalnum():
        return json.dumps(dict(result=False,
                               result_no=-2,
                               message='error name'))

    if len(user_name) > 32:
        return json.dumps(dict(result=False,
                               result_no=-3,
                               message='error name len'))

    if len(user_pwd) > 32:
        return json.dumps(dict(result=False,
                               result_no=-4,
                               message='error pwd len'))

    return __user_register(account_name=user_name,
                           account_password=user_pwd,
                           device_id=device_id,
                           is_tourist=is_tourist)


def __user_login(account_name='', account_password=''):
    get_result = util.GetOneRecordInfo(USER_TABLE_NAME,
                                       dict(account_name=account_name,
                                            account_password=account_password))
    logger.info(get_result)
    if get_result is None:
        return json.dumps(dict(result=False, id=11, result_no=3300010007,
                          message='account name or password error!'))

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


@webserviceHandle('/bind')
def user_bind():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    tourist_id = request.args.get('tid')
    logger.info('bind name:%s pwd:%s %s', user_name, user_pwd, tourist_id)

    if not user_name.isalnum():
        return json.dumps(dict(result=False,
                               result_no=-2,
                               message='error name'))

    if len(user_name) > 32:
        return json.dumps(dict(result=False,
                               result_no=-3,
                               message='error name len'))

    if len(user_pwd) > 32:
        return json.dumps(dict(result=False,
                               result_no=-4,
                               message='error pwd len'))

    get_result = util.GetOneRecordInfo(USER_TABLE_NAME,
                                       dict(account_name=tourist_id,
                                            account_password=TOURIST_PWD))
    if get_result is None:
        return json.dumps(dict(result=False,
                               message='account name or password error!'))

    result = util.UpdateWithDict(USER_TABLE_NAME,
                                 dict(account_name=user_name,
                                      account_password=user_pwd,
                                      device_id=''),
                                 dict(id=get_result['id']))
    logger.info('bind result:%s', result)
    return json.dumps(dict(result=result))


@webserviceHandle('/query_touristid')
def query_touristid():
    device_id = request.args.get('deviceid')

    get_result = util.GetOneRecordInfo(USER_TABLE_NAME,
                                       dict(device_id=device_id))
    if get_result is None:
        return json.dumps(dict(result=False,
                               message='query tourist fail!'))

    logger.info('tourist query :%s', get_result)
    return json.dumps(dict(result=True,
                           account_name=get_result['account_name'],
                           account_password=get_result['account_password']))


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
