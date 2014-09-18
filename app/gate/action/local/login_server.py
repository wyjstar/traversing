# -*- coding:utf-8 -*-
"""
created by server on 14-6-28下午4:08.
"""
import time
from gfirefly.dbentrust import util
from app.gate.action.node import net
from app.gate.core.user import User
from app.gate.core.users_manager import UsersManager
from app.proto_file import account_pb2
from app.gate.service.local.gateservice import local_service_handle
from gfirefly.server.globalobject import GlobalObject


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
    sql_result = util.GetOneRecordInfo('tb_account', dict(uuid=uuid))
    if sql_result is not None:
        print sql_result
        return sql_result['id']
    else:
        data = dict(uuid=uuid, last_login=0, create_time=time.time())
        insert_result = util.InsertIntoDB('tb_account', data)
        if insert_result:
            sql_result = util.GetOneRecordInfo('tb_account', dict(uuid=uuid))
            return sql_result['id']

    return 0
