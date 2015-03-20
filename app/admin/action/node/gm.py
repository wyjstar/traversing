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
import time
from app.proto_file.db_pb2 import Mail_PB
from app.admin.redis_mode import tb_guild_info, tb_guild_name, tb_character_info
from app.admin.action.root.netforwarding import push_message
from app.proto_file.db_pb2 import Stamina_DB
from shared.utils import trie_tree


remote_gate = GlobalObject().remote['gate']
MASTER_WEBPORT = GlobalObject().allconfig['master']['webport']


@webserviceHandle('/gmtestdata:name')
def gm_add_test_data(account_name='hello world'):
    # account_name = request.args.get('name')
    return account_name


@webserviceHandle('/gm', methods=['post', 'get'])
def gm():
    response = {}
    res = {}
    admin_command = ['update_excel', 'get_user_info', 'send_mail']
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
        if res['success'] == 2:
            com = t_dict['command'] + "(t_dict)"
            res = eval(com)

    return json.dumps(res)


def update_excel(args):
    url = args['excel_url']
    urllib.urlretrieve(url, 'config/excel_cpickle')
    com = "curl localhost:%s/reloadmodule" % MASTER_WEBPORT
    os.system(com)
    return {"success": 1}


def get_user_info(args):
    print args
    if args['search_type'] == '1':
        character_obj = tb_character_info.getObj(args['search_value'])
        isexist = character_obj.exists()
    elif args['search_type'] == '2':
        nickname_obj = tb_character_info.getObj('nickname')
        isexist = nickname_obj.hexists(args['search_value'])
        pid = nickname_obj.hget(args['search_value'])
        character_obj = tb_character_info.getObj(pid)
    else:
        return {'success': 0, 'message': 1}

    if not isexist:
        return {'success': 0, 'message': 2}

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
    mail = Mail_PB()
    # mail.sender_id = player.base_info.id
    mail.sender_name = args['sender_name']
    mail.sender_icon = int(args['sender_icon'])
    mail.receive_name = ''
    mail.title = args['title']
    mail.content = args['text']
    mail.mail_type = 2
    mail.prize = ''
    mail.send_time = int(time.time())
    # mail_data = mail.SerializePartialToString()

    if args['uids'] == '0':
        users = tb_character_info.smem('all')
        print users
        for uid in users:
            mail.receive_id = uid
            push_message('receive_mail_remote', uid,
                         mail.SerializeToString())
    else:
        for uid in args['uids'].split(';'):
            mail.receive_id = int(uid)
            mail_data = mail.SerializeToString()
            push_message('receive_mail_remote', int(uid),
                         mail.SerializeToString())
    return {'success': 1}


def modify_user_info(args):
    # oldvcharacter = VCharacterManager().get_by_id(int(args.get('uid')))
    # if oldvcharacter:
    #     args = (args.get('command'), oldvcharacter.dynamic_id,
    #             cPickle.dumps(args))
    #     child_node = groot.child(oldvcharacter.node)
    #     return child_node.callbackChild(*args)
    # else:
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    if args['attr_name'] == 'user_level':
        data = {'level': int(args['attr_value'])}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'vip_level':
        data = {'vip_level': int(args['attr_value'])}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'user_exp':
        data = {'exp': int(args['attr_value'])}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'buy_stamina_times':
        stamina_data = character_obj.hget('stamina')
        stamina = Stamina_DB()
        stamina.ParseFromString(stamina_data)
        stamina.buy_stamina_times = int(args['attr_value'])
        data = {'stamina': stamina.SerializeToString()}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'stamina':
        finance = character_obj.hget('finances')
        finance[7] = int(args['attr_value'])
        data = {'finances': finance}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'nickname':
        nickname = args['attr_value']
        match = re.search(u'[\uD800-\uDBFF][\uDC00-\uDFFF]', nickname)
        if match:
            return {'success': 0, 'message': 2}

        if trie_tree.check.replace_bad_word(nickname) != nickname:
            return {'success': 0, 'message': 2}

        nickname_obj = tb_character_info.getObj('nickname')
        result = nickname_obj.hsetnx(args['attr_value'], args['uid'])
        if result:
            data = {'nickname': args['attr_value']}
            character_obj.hmset(data)
            return {'success': 1}
        else:
            return {'success': 0, 'message': 0}
    else:
        return {'success': 0, 'message': 2}
