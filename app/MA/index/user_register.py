# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.dbentrust.dbpool import dbpool
from numbers import Number
from flask import request
import MySQLdb
import time
import uuid

account_login_cache = []
USER_TABLE_NAME = 'tb_user'


def get_uuid():
    return uuid.uuid1().get_hex()


def insert_execute(table_name, attr):
    sql = 'insert into %s ' % table_name

    keys_str = MySQLdb.escape_string(str(tuple(attr.keys())).replace('\'', '`'))
    values_str = ["%s," % val if isinstance(val, Number) else
                  "'%s'," % MySQLdb.escape_string(str(val)) for val in attr.values()]
    values_str = ''.join(values_str)[:-1]

    sql = '%s %s values (%s)' % (sql, keys_str, values_str)
    print sql
    return SqlExecute(sql)


def select_execute(table_name, condition):
    print condition
    sql = 'select * from %s where ' % table_name
    for _ in condition.items():
        if isinstance(_[1], Number):
            sql += " `%s`=%s AND" % (_[0], _[1])
        else:
            sql += " `%s`='%s' AND " % (_[0], MySQLdb.escape_string(str(_[1])))
    sql = sql[:-4]
    print sql
    return SqlExecute(sql)


class SqlExecute(object):
    def __init__(self, sql):
        self._cursor = None

        conn = dbpool.connection()
        self._cursor = conn.cursor()
        try:
            result = self._cursor.execute(sql)
            conn.commit()
            # print self._cursor._cursor.__dict__
            # print conn._con.__dict__
        except:
            pass
        finally:
            # self._cursor.close()
            conn.close()

    @property
    def rowcount(self):
        return self._cursor.rowcount

    @property
    def lastrowid(self):
        return self._cursor.lastrowid

    @property
    def record(self):
        return self._cursor.fetchone()


def get_id():
    """取得帐号唯一ID """
    sql_exe = SqlExecute('update account_sequence set id = last_insert_id(id+1)')
    return sql_exe.lastrowid


def __user_register(account_name='', account_password=''):
    # todo check account name password
    sql_result = select_execute(USER_TABLE_NAME, dict(account_name=account_name))
    if sql_result.rowcount == 1:
        return str({'result': False, 'message': 'account name is exist'})

    user = dict(id=get_uuid(),
                account_name=account_name,
                account_password=account_password,
                last_login=0,
                create_time=int(time.time()))

    sql_result = insert_execute(USER_TABLE_NAME, user)
    if sql_result.rowcount == 1:
        return str({'result': True, 'passport': user.get('uuid')})
    return str({'result': False, 'message': 'error'})


@webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    print 'register name:', user_name, ' pwd:', user_pwd

    return __user_register(account_name=user_name, account_password=user_pwd)


def __user_login(account_name='', account_password=''):
    sql_result = select_execute(USER_TABLE_NAME, dict(account_name=account_name,
                                                      account_password=account_password))
    user_data = sql_result.record
    print user_data
    if not user_data:
        return str({'result': False, 'message': 'account name or password error!'})

    if user_data[0] not in account_login_cache:
        account_login_cache.append(user_data[0])
    return str({'result': True, 'passport': user_data[0]})


@webserviceHandle('/login')
def user_login():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    print 'login name:', user_name, ' pwd:', user_pwd
    return __user_login(account_name=user_name, account_password=user_pwd)


@webserviceHandle('/verify')
def user_verify():
    user_passport = request.args.get('passport')
    print account_login_cache
    if user_passport not in account_login_cache:
        return str({'result': False})
    return str({'result': True})


if __name__ == '__main__':
    dbconfig = {'host': '127.0.0.1',
                'user': 'test',
                'passwd': 'test',
                'db': 'db_traversing',
                'port': 8066,
                'charset': 'utf8'}

    dbpool.initPool(**dbconfig)
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

    sql_result = insert_execute(USER_TABLE_NAME, user)
    record = sql_result.record
