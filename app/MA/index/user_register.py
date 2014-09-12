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


def get_id():
    """取得帐号唯一ID """
    sql_exe = SqlExecute('update account_sequence set id = last_insert_id(id+1)')
    return sql_exe.lastrowid


def __user_register(user):
    sql = 'insert into tb_account %s values %s' % (str(user.keys()).replace('\'', ''),
                                                   user.values())
    sql = sql.replace('[', '(').replace(']', ')')
    print sql
    sql_result = SqlExecute(sql)
    if sql_result.rowcount == 1:
        sql2 = 'insert into tb_account_mapping (account_token, id) values (\'%s\', \'%s\')' % \
               (user.get('uuid'), user.get('id'))
        sql_result2 = SqlExecute(sql2)
        if sql_result2.rowcount != 1:
            print 'error insert tb_account_mapping ', sql2
            return False
        return True
    return False


@webserviceHandle('/register')
def user_register():
    user_name = request.args.get('name')
    user_pwd = request.args.get('pwd')

    print 'register name:', user_name, ' pwd:', user_pwd

    account_id = get_id()
    user_uuid = get_uuid()
    user_data = dict(id=account_id,
                     uuid=user_uuid,
                     account_name=user_name,
                     account_password=user_pwd,
                     last_login=0,
                     create_time=int(time.time()))

    if not __user_register(user_data):
        return {'result': False}

    return {'result': True, 'passport': user_uuid}


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

    data = dict(id=1,
                uuid='safe',
                account_name='register',
                account_password='111',
                last_login=0,
                create_time=int(time.time()))
    __user_register(data)
