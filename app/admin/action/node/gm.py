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
import urllib
import re
import os
from app.admin.redis_mode import tb_guild_info, tb_guild_name, tb_character_info
from app.proto_file.db_pb2 import Mail_PB


remote_gate = GlobalObject().remote['gate']


@webserviceHandle('/gmtestdata:name')
def gm_add_test_data(account_name='hello world'):
    # account_name = request.args.get('name')
    return account_name


@webserviceHandle('/gm', methods=['post', 'get'])
def gm():
    response = {}
    res = {}
    admin_command = ['update_excel', 'send_mail', 'get_user_info']
    if request.args:
        t_dict = request.args
    else:
        t_dict = request.form

    logger.info('gm2admin,command:%s', t_dict['command'])

    if t_dict['command'] in admin_command:
        com = t_dict['command'] + "(t_dict)"
        res = eval(com)
    else:
        res = remote_gate.from_admin_rpc_remote(cPickle.dumps(t_dict))

    return json.dumps(res)


def update_excel(args):
    url = args['excel_url']
    urllib.urlretrieve(url, 'config/excel_cpickle')
    com = "curl localhost:30002/reloadmodule"
    os.system(com)
    return {"success": 1}


def get_user_info(args):
    print args
    character_obj = tb_character_info.getObj(args['uid'])
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    character_info = character_obj.hmget(['nickname', 'attackpoint',
                                          'heads', 'upgrade_time',
                                          'level', 'id', 'exp',
                                          'vip_level', 'register_time',
                                          'upgrade_time', 'guild_id',
                                          'position'])
    if character_info['guild_id'] == 'no':
        position = 0
        guild_name = ''
        guild_id = ''
    else:
        guild_id = character_info['guild_id']
        guild_obj = tb_guild_info.getObj()
        if guild_obj.exists():
            guild_info = guild_obj.hmget(['name'])
            positon = character_info['positon']
            guild_name = guild_info['name']
        else:
            position = 0
            guild_name = ''

    return {'success': 1,
            'message': {'uid': character_info['id'],
                        'nickname': character_info['nickname'],
                        'level': character_info['level'],
                        'exp': character_info['exp'],
                        'vip_level': character_info['vip_level'],
                        'register_time': character_info['register_time'],
                        'recently_login_time': character_info['upgrade_time'],
                        'guild_id': guild_id,
                        'guild_name': guild_name,
                        'position': position}}


def send_mail(args):
    print "======1=========1========1=========1====="
    users = tb_character_info.smem('all')
    print users
    #mail = Mail_PB()
    # mail.sender_id = player.base_info.id
    #mail.sender_name = player.base_info.base_name
    #mail.sender_icon = player.base_info.head
    #mail.receive_id = target_id
    #mail.receive_name = ''
    #mail.title = title
    #mail.content = content
    #mail.mail_type = MailComponent.TYPE_MESSAGE
    #mail.prize = ''
    #mail.send_time = int(time.time())
    #mail_data = mail.SerializePartialToString()

    #if args['uids'] == '0':
    #    for uid in []:
    #        netforwarding.push_message_remote('receive_mail_remote',
    #                                          uid, mail_data)
    #else:
    #    for uid in args['uids'].split(';'):
    #        netforwarding.push_message_remote('receive_mail_remote',
    #                                          int(uid), mail_data)
    return {"success": 1}
