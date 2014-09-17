# -*- coding:utf-8 -*-
"""
created by server on 14-6-28下午4:08.
"""
import json
from numbers import Number
import MySQLdb
import time
from app.gate.action.node import net
from app.gate.core.user import User
from app.gate.core.users_manager import UsersManager
from app.proto_file import account_pb2
from app.gate.service.local.gateservice import local_service_handle
from gfirefly.dbentrust.dbpool import dbpool
from gfirefly.server.globalobject import GlobalObject
from shared.data_collection.static_api import write


@local_service_handle
def server_login_2(command_id, dynamic_id, request_proto):
    """ 帐号登录
    @param command_id:
    @param dynamic_id:
    @param request_proto:
    @return:
    """

    # 登录数据解析
    account_key = account_pb2.AccountLoginRequest()
    account_key.ParseFromString(request_proto)
    key = account_key.passport

    account_key = account_pb2.AccountResponse()

    # 通知帐号服
    print 'rpc account verify:', key
    result = GlobalObject().remote['login'].callRemote('account_verify', key)
    result = eval(result)
    print 'verify result:', result

    if result.get('result') is True:  # 登录成功
        uuid = result.get('uuid')
        print 'login uuid:', uuid
        account_id = get_account_id(uuid)
        if account_id == 0:
            account_key.result = False
        else:
            account_key.result = __manage_user(uuid, account_id, '', '', dynamic_id)
    else:
        account_key.result = False
    return account_key.SerializeToString()


def __manage_user(token, account_id, user_name, password, dynamic_id):
    """管理用户
    """
    user = UsersManager().get_by_id(account_id)
    if user and user.dynamic_id != dynamic_id:
        print 'user exit! info:', user
        if not net.change_dynamic_id(user.dynamic_id, dynamic_id):
            print 'error!, change user id fail, dynamic:', user.dynamic_id
            return False
        # user.dynamic_id = dynamic_id
    else:
        user = User(token, account_id, user_name, password, dynamic_id)
        print 'add user:', user
        UsersManager().add_user(user)
    print 'user mana:', UsersManager()._users
    return True


def get_account_id(uuid):
    sql_result = select_execute('tb_account', dict(uuid=uuid))
    if sql_result.rowcount == 1:
        record = sql_result.record
        print record
        print record[0]
        return record[0]
    else:
        data = dict(uuid=uuid, last_login=0, create_time=time.time())
        insert_result = insert_execute('tb_account', data)
        if insert_result.rowcount == 1:
            sql_result = select_execute('tb_account', dict(uuid=uuid))
            record = sql_result.record
            return record[0]

    return 0


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
