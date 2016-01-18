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
from app.admin.redis_mode import tb_guild_info, tb_character_info
from app.admin.action.root.netforwarding import push_message
from app.proto_file.db_pb2 import Stamina_DB
from shared.utils import trie_tree
from app.game.core.stage.stage import Stage
from shared.db_opear.configs_data import game_configs
import zipfile
from app.proto_file.account_pb2 import AccountKick
from gfirefly.dbentrust import util


remote_gate = GlobalObject().remote.get('gate')
MASTER_WEBPORT = GlobalObject().allconfig['master']['webport']


@webserviceHandle('/gmtestdata:name')
def gm_add_test_data(account_name='hello world'):
    # account_name = request.args.get('name')
    return account_name


@webserviceHandle('/gm', methods=['post', 'get'])
def gm():
    print("gm================")
    response = {}
    res = {}
    admin_command = ['reset_star_gift', 'update_excel', 'get_user_info', 'send_mail',
                     'get_user_hero_chips', 'get_user_eq_chips',
                     'get_user_finances', 'get_user_items',
                     'get_user_guild_info', 'get_user_heros',
                     'get_user_eqs', 'copy_user', 'update_server_list',
                     'add_push_message', 'kick_player']
    print request.args, type(request.args)
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
            logger.debug("gm=======%s" % com)
            res = eval(com)
    logger.info('######################################,server2gm:%s', res)

    return json.dumps(res)


def reset_star_gift(args):
    uids = tb_character_info.smem('all')
    for uid in uids:
        character_obj = tb_character_info.getObj(uid)
        data = {'award_info': {}}
        character_obj.hmset(data)
    return {"success": 1}


def update_server_list(args):
    dataversion = args['dataversion']
    dataversion = json.loads(dataversion)
    with open('/tmp/server_list.json', 'w') as f:
        json.dump(dataversion, f)

    os.system("cp /tmp/server_list.json server_list.json")
    com = "curl localhost:%s/reloadmodule" % MASTER_WEBPORT
    os.system(com)
    return {"success": 1}


def kick_player(args):
    response = AccountKick()
    response.id = 3
    response.channel = args['channel']
    response.client_os = args['client_os']
    print "kick_player=========response:", response
    remote_gate.push_notice_remote(11,
                                   response.SerializeToString())

    return {"success": 1}


def update_excel(args):
    print("update_excell=========1")
    if 'excel_url' in args:
        url = args['excel_url']
    else:
        logger.error("excel_url not exists!!!")
        # url="http://192.168.1.60:2600/static/upload/server_cfg_1435338130"
        return {'success': 0, 'message': 1}

    res = urllib.urlretrieve(url, '/tmp/config.zip')
    print res
    print("update_excell=========2")
    os.system("cd /tmp; unzip -o config.zip")
    os.system("cp /tmp/excel_cpickle config/excel_cpickle")
    os.system("cp -r /tmp/lua/. app/battle/src/app/datacenter/template/config/")

    com = "curl localhost:%s/reloadmodule" % MASTER_WEBPORT
    os.system(com)

    # 通知客户端下线更新
    if int(args['force_client_update']):
        response = AccountKick()
        response.id = 3
        response.channel = 'all'
        response.client_os = 'all'
        remote_gate.push_notice_remote(11,
                                       response.SerializeToString())
        print 'update_excel,====response:', response

    return {"success": 1}


def get_user_info(args):
    if args['search_type'] == '1':
        character_obj = tb_character_info.getObj(args['search_value'])
        isexist = character_obj.exists()
    elif args['search_type'] == '2':
        nickname_obj = tb_character_info.getObj('nickname')
        isexist = nickname_obj.hexists(args['search_value'])
        pid = nickname_obj.hget(args['search_value'])
        character_obj = tb_character_info.getObj(pid)
    elif args['search_type'] == '3':
        uuid = args['search_value']
        sql_result = util.GetOneRecordInfo('tb_account', dict(uuid=uuid))
        if sql_result is not None:
            pid = sql_result['id']
            character_obj = tb_character_info.getObj(pid)
            isexist = character_obj.exists()
        else:
            return {'success': 0, 'message': 3}
    else:
        return {'success': 0, 'message': 1}

    if not isexist:
        return {'success': 0, 'message': 2}

    character_info = character_obj.hmget(['nickname', 'attackPoint',
                                          'heads', 'upgrade_time',
                                          'level', 'id', 'exp',
                                          'vip_level', 'register_time',
                                          'upgrade_time', 'guild_id',
                                          'position', 'finances',
                                          'recharge_accumulation',
                                          'gen_balance'])
    finances = character_info['finances']
    if character_info['guild_id'] == 'no':
        position = 0
        guild_name = ''
        guild_id = ''
    else:
        guild_id = character_info['guild_id']
        guild_obj = tb_guild_info.getObj(guild_id)
        if guild_obj.exists():
            guild_info = guild_obj.hmget(['name'])
            position = character_info['position']
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
                        'gold': finances[2],
                        'gold_all_cost': finances[9],
                        'gold_all_recharge': character_info['recharge_accumulation'],
                        'gold_all_send': character_info['gen_balance'],
                        'position': position}}


def send_mail(args):
    gain_info = []
    if args.get('awards'):
        a = args.get('awards').split('|')
        for b in a:
            award = b.split(':')
            gain_info.append({award[0]: [award[2], award[2], award[1]]})

    mail = Mail_PB()
    # mail.sender_id = player.base_info.id
    mail.sender_name = args['sender_name']
    mail.sender_icon = int(args['sender_icon'])
    # mail.receive_name = ''
    mail.title = args['title']
    mail.content = args['text']
    mail.mail_type = 2
    if gain_info:
        mail.prize = str(gain_info)
    mail.send_time = int(time.time())
    # mail_data = mail.SerializePartialToString()

    if args['uids'] == '0':
        users = tb_character_info.smem('all')
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
    if not args['attr_name'] or not args['attr_value']:
        return {'success': 0, 'message': 5}
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    if args['attr_name'] == 'user_level':
        data = {'level': int(args['attr_value'])}
        character_obj.hmset(data)
        return {'success': 1}
    elif args['attr_name'] == 'newbee_guide':
        data = {'current_newbee_guide': int(args['attr_value'])}
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
    elif args['attr_name'] == 'stage1':
        return {'success': 0}
        stage_ids = args['attr_value'].split(';')
        for stage_id in stage_ids:
            stage_id = int(stage_id)

            stages = character_obj.hget('stage_info')
            stage_info = game_configs.stage_config.get('stages').get(stage_id)
            if not stage_info:
                return {'success': 0, 'message': 4}
            if not next_stages.get(stage_id):
                return {'success': 0, 'message': 4}
            if game_configs.stage_config.get('stages').get(stage_id)['type'] != 1:
                return {'success': 0, 'message': 4}
            stage_objs = {}
            for stage_id_a, stage in stages.items():
                stage_objs[stage_id_a] = Stage.loads(stage)

            stage_obj = get_stage(stage_objs, stage_id)
            stage_obj.state = 1
    elif args['attr_name'] == 'stage':
        stage_id = int(args['attr_value'])
        attr_value = int(args['attr_value'])
        stages = character_obj.hget('stage_info')

        next_stages = game_configs.stage_config.get('condition_mapping')

        stage_info = game_configs.stage_config.get('stages').get(stage_id)
        if not stage_info:
            return {'success': 0, 'message': 4}
        if not next_stages.get(stage_id):
            return {'success': 0, 'message': 4}
        if game_configs.stage_config.get('stages').get(stage_id)['type'] != 1:
            return {'success': 0, 'message': 4}
        stage_objs = {}
        for stage_id_a, stage in stages.items():
            stage_objs[stage_id_a] = Stage.loads(stage)

        stage_obj = get_stage(stage_objs, stage_id)
        stage_obj.state = -1
        first_stage_id = game_configs.stage_config.get('first_stage_id')
        stage_id_a = stage_id

        while True:
            if not next_stages.get(stage_id_a):
                break
            for stage in [get_stage(stage_objs, stage_id_1) for stage_id_1 in next_stages.get(stage_id_a)]:
                stage.state = -2
            for stage_id_1 in next_stages.get(stage_id_a):
                if game_configs.stage_config.get('stages').get(stage_id_1)['type'] == 1:
                    stage_id_a = stage_id_1
                    break
            else:
                break

        while True:
            the_last_stage_id = game_configs.stage_config.get('stages').get(stage_id)['condition']

            stage_obj = get_stage(stage_objs, stage_id)
            stage_obj.state = 1

            if next_stages.get(the_last_stage_id):
                for stage in [get_stage(stage_objs, stage_id_1) for stage_id_1 in next_stages.get(the_last_stage_id)]:
                    if stage_id != stage.stage_id:
                        stage.state = -1

            if stage_id == first_stage_id:
                break
            else:
                stage_id = the_last_stage_id

        stage_obj = get_stage(stage_objs, attr_value)
        stage_obj.state = -1
        if game_configs.stage_config.get('stages').get(attr_value)['section'] == 1:
            chapter_id = game_configs.stage_config.get('stages').get(attr_value)['chapter']
        else:
            chapter_id = game_configs.stage_config.get('stages').get(attr_value)['chapter'] + 1

        data = {'stage_progress': attr_value, 'stage_info': dict([(stage_id, stage.dumps()) for stage_id, stage in stage_objs.iteritems()]), 'plot_chapter': chapter_id}
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
        return {'success': 0, 'message': 3}


def get_stage(stage_objs, stage_id):
        stage_obj = stage_objs.get(stage_id)
        if not stage_obj:
            stage_obj = Stage(stage_id, state=-2)
            stage_objs[stage_id] = stage_obj
        return stage_obj


def get_user_hero_chips(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    hero_chips_data = character_obj.hget('hero_chips')
    message = {}
    if hero_chips_data:
        for no, num in hero_chips_data.items():
            message[no] = num

    return {'success': 1, 'message': message}


def get_user_eq_chips(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    equipment_chips = character_obj.hget('equipment_chips')
    message = {}
    if equipment_chips:
        for no, num in equipment_chips.items():
            message[no] = num

    return {'success': 1, 'message': message}


def get_user_items(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    items = character_obj.hget('items')
    message = {}
    if items:
        for no, num in items.items():
            message[no] = num

    return {'success': 1, 'message': message}


def get_user_finances(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    finances = character_obj.hget('finances')
    del finances[0]

    return {'success': 1, 'message': finances}


def get_user_guild_info(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    guild_id = character_obj.hget('guild_id')
    if guild_id == 'no':
        return {'success': 0, 'message': 2}

    message = {}
    position = character_obj.hget('position')
    contribution = character_obj.hget('contribution')
    all_contribution = character_obj.hget('all_contribution')
    k_num = character_obj.hget('k_num')
    worship = character_obj.hget('worship')
    worship_time = character_obj.hget('worship_time')
    exit_time = character_obj.hget('exit_time')
    message = {'guild_id': guild_id,
               'position': position,
               'contribution': contribution,
               'all_contribution': all_contribution,
               'k_num': k_num,
               'worship': worship,
               'worship_time': worship_time,
               'exit_time': exit_time}

    return {'success': 1, 'message': message}


def ban_user(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}
    closure = character_obj.hget('closure')
    data = {'closure': int(args['lock_time'])}
    character_obj.hmset(data)
    return {'success': 1}


def ban_speak(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}
    closure = character_obj.hget('gag')
    data = {'gag': int(args['lock_time'])}
    character_obj.hmset(data)
    return {'success': 1}


def get_user_heros(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}
    message = {}

    char_obj = character_obj.getObj('heroes')
    heros = char_obj.hgetall()

    for hid, data in heros.items():
        hero_mes = {}
        hero_mes['level'] = data['level']
        hero_mes['exp'] = data['exp']
        hero_mes['break_level'] = data['break_level']
        hero_mes['refine'] = data['refine']
        if data['is_guard']:
            hero_mes['is_guard'] = 1
        else:
            hero_mes['is_guard'] = 0

        if data['is_online']:
            hero_mes['is_online'] = 1
        else:
            hero_mes['is_online'] = 0

        message[data['hero_no']] = hero_mes

    return {'success': 1, 'message': message}


def get_user_eqs(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}
    message = {}
    # eqs = character_obj.hget('equipments')

    char_obj = character_obj.getObj('equipments')
    eqs = char_obj.hgetall()

    for hid, data in eqs.items():
        equipment_info = data.get('equipment_info')
        equipment_id = data.get('id')

        eq_mes = {}
        eq_mes['eq_no'] = equipment_info['equipment_no']
        eq_mes['slv'] = equipment_info['slv']
        eq_mes['alv'] = equipment_info['alv']
        eq_mes['prefix'] = equipment_info['prefix']

        message[equipment_id] = eq_mes

    return {'success': 1, 'message': message}


def copy_user(args):
    character_obj = tb_character_info.getObj(int(args.get('uid')))
    if not character_obj.exists():
        return {'success': 0, 'message': 1}

    be_copy_character_obj = tb_character_info.getObj(int(args.get('be_copy_uid')))
    if not be_copy_character_obj.exists():
        return {'success': 0, 'message': 2}
    be_copy_character_info = be_copy_character_obj.hgetall()

    character_obj.hmset(be_copy_character_info)

    return {'success': 1}


def add_push_message(args):
    uid = int(args.get('uid'))
    mtype = int(args.get('mtype'))
    msg = args.get('msg')
    remote_gate['push'].add_push_message_remote(uid, mtype, msg,
                                                int(time.time()))
    return {'success': 1}
