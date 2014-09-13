# -*- coding:utf-8 -*-
"""
created by sphinx on 11/9/14.
"""
from gfirefly.server.globalobject import webserviceHandle
from gfirefly.dbentrust.dbpool import dbpool
from numbers import Number
from flask import request
import time
import uuid

account_login_cache = []

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
    sql_format = 'select * from tb_name_mapping where account_name=\'%s\''
    sql_result = SqlExecute(sql_format % account_name)
    if sql_result.rowcount == 1:
        return str({'result': False, 'message': 'account name is exist'})

    user = dict(id=get_id(),
                uuid=get_uuid(),
                account_name=account_name,
                account_password=account_password,
                last_login=0,
                create_time=int(time.time()))

    keys_str = str(tuple(user.keys())).replace('\'', '`')
    values_str = ["%s," % val if isinstance(val, Number) else
                  "'%s'," % str(val).replace("'", "\\'") for val in user.values()]
    values_str = ''.join(values_str)[:-1]
    sql = """INSERT INTO `tb_account` %s values (%s);""" % (keys_str, values_str)

    print sql
    sql_result = SqlExecute(sql)
    if sql_result.rowcount == 1:
        sql2 = 'insert into tb_name_mapping (account_name, id) values (\'%s\', %s)' % \
               (user.get('account_name'), user.get('id'))
        print sql2
        sql_result2 = SqlExecute(sql2)
        print sql_result2.rowcount
        if sql_result2.rowcount != 1:
            print 'error insert tb_account_mapping ', sql2
            return str({'result': False})
        return str({'result': True, 'passport': user.get('uuid')})
    return str({'result': False, 'message': 'error'})


@webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    print 'register name:', user_name, ' pwd:', user_pwd

    return __user_register(account_name=user_name, account_password=user_pwd)


def __user_login(account_name='', account_password=''):
    sql_format = 'select * from tb_name_mapping where account_name=\'%s\''
    sql_result = SqlExecute(sql_format % account_name)
    record = sql_result.record
    print record
    if not record:
        return str({'result': False, 'message': 'account name error!'})

    sql_format = 'select * from tb_account where id=%s'
    sql_result = SqlExecute(sql_format % record[1])
    user_data = sql_result.record

    print user_data
    if user_data[3] != account_password:
        return str({'result': False, 'message': 'account password error!'})

    if user_data[1] not in account_login_cache:
        account_login_cache.append(user_data[1])
    return str({'result': True, 'passport': user_data[1]})


@webserviceHandle('/login')
def user_login():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')
    print 'login name:', user_name, ' pwd:', user_pwd
    return __user_login(account_name=user_name, account_password=user_pwd)


@webserviceHandle('/verify')
def user_verify():
    user_passport = request.args.get('passport')
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

    # SqlExecute('delete from tb_account where id=1')
