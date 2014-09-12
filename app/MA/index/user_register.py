# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
import gevent
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.server.globalobject import webserviceHandle
from flask import request
import time
import uuid


def get_uuid():
    return uuid.uuid1().get_hex()


class SqlExecute(object):
    def __init__(self, sql):
        self._cursor = None

        conn = dbpool.connection()
        self._cursor = conn.cursor()
        try:
            self._cursor.execute(sql)
            conn.commit()
        finally:
            self._cursor.close()
            conn.close()
    @property
    def cursor(self):
        return self._cursor


def get_id():
    """取得帐号唯一ID """
    print 'begin'
    sql_exe = SqlExecute('update account_sequence set id = last_insert_id(id+1)')
    print 'end'
    return sql_exe.cursor.lastrowid


def __check_register_name(user_name):
    # mapping_data = tb_name_mapping.getObjData(user_name)
    # if not mapping_data:
    #     return True

    return False


# @webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')

    if not __check_register_name(user_name):
        print 'user is exist user', user_name
        return {'result': False}

    account_id = get_id()
    uuid = get_uuid()
    data = dict(id=account_id, uuid=uuid, account_name=user_name, account_password=user_pwd, last_login=0,
                create_time=int(time.time()))
    # account_mmode = tb_account.new(data)
    # account_mmode.insert()
    #
    # md5 = hashlib.md5()
    # md5.update('%s:%s' % (account_id, uuid))
    # token = md5.hexdigest()
    # data = dict(id=account_id, account_token=token)
    # account_mapping = tb_account_mapping.new(data)
    # account_mapping.insert()
    #
    # data = dict(account_name=user_name, id=account_id)
    # name_mapping = tb_name_mapping.new(data)
    # name_mapping.insert()

    # return {'result': True, 'token': token, 'account_id': account_id}


if __name__ == '__main__':
    dbconfig = {'host': '127.0.0.1',
                'user': 'test',
                'passwd': 'test',
                'db': 'db_traversing',
                'port': 8066,
                'charset': 'utf8'}

    dbpool.initPool(**dbconfig)
    # print get_id()
    threads = []
    for _ in range(100):
        threads.append(gevent.spawn(get_id))

    gevent.joinall(threads)
