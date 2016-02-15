# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午12:11.
"""
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.core.users_manager import UsersManager
from app.gate.service.local.gateservice import local_service_handle
from app.gate.core.virtual_character import VirtualCharacter
from app.gate.core.virtual_character_manager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import game_pb2
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action
import time
from app.proto_file.account_pb2 import AccountKick
# from app.gate.action.node.net import kick_by_id_remote

groot = GlobalObject().root


@local_service_handle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录 """
    ip = groot.child('net').get_ipaddress_remote(dynamic_id)
    logger.debug("==============character_login_4===========")
    argument = game_pb2.GameLoginRequest()
    argument.ParseFromString(request_proto)
    pay_arg = dict(plat_id=argument.plat_id,
                   platform=argument.platform,
                   openid=argument.open_id,
                   openkey=argument.open_key,
                   pay_token=argument.pay_token,
                   appid=argument.appid,
                   appkey=argument.appkey,
                   pf=argument.pf,
                   pfkey=argument.pfkey,
                   zoneid=argument.zoneid,
                   login_channel=argument.login_channel)

    data = __character_login(dynamic_id, pay_arg)

    response = game_pb2.GameLoginResponse()

    if not data.get('result', True):
        response.res.result = False
        response.res.result_no = data.get('result_no', 0)
        return response.SerializePartialToString()

    player_data = data.get('player_data')
    response.ParseFromString(player_data)

    login_time = int(time.time())
    if response.closure > login_time or response.closure == -2:
        msg = AccountKick()
        msg.id = 2
        msg.time = response.closure
        groot.child('net').kick_by_id_remote(msg.SerializeToString(),
                                             dynamic_id)

        response.res.result = False
        response.res.result_no = 4004
        logger.error("player was banned!")
        return response.SerializePartialToString()

    # argument.plat_id = 0
    # argument.client_version = '0.0.0.1'
    # argument.system_software = '1.1'
    # argument.system_hardware = '2.2'
    # argument.telecom_oper = 'tx'
    # argument.network = 'wifi'
    # argument.screen_width = 1024
    # argument.screen_hight = 2048
    # argument.density = 256
    # argument.login_channel = 512
    # argument.mac = '1.1.1'
    # argument.cpu_hardware = 'intel'
    # argument.memory = 1024
    # argument.gl_render = 'abc'
    # argument.gl_version = 'abcd'
    # argument.device_id = '1x2y'

    tlog_action.log('PlayerLogin', response, argument, ip)
    if data.get('is_new_character'):
        tlog_action.log('PlayerRegister', response, argument, ip)

    nickname = response.nickname
    if nickname and response.gag < login_time and response.gag != -2:
        # 聊天室登录
        GlobalObject().child('chat').login_chat_remote(
            dynamic_id, response.id, nickname, response.guild_id, response.gag)
    return response.SerializePartialToString()


def __character_login(dynamic_id, pay_arg):

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    logger.info("user_id:%d", dynamic_id)
    if not user:
        logger.error("user not exist!")
        return {'result': False, 'result_no': 4001}

    v_character = VCharacterManager().get_by_id(user.user_id)
    print("__character_login %s" % v_character)
    if v_character:
        old_dynamic_id = v_character.dynamic_id
        v_character.dynamic_id = dynamic_id
        VCharacterManager().update_dynamic_id(old_dynamic_id, v_character)
        print("old dynamic_id %s, new_dynamic_id %s" %
              (old_dynamic_id, dynamic_id))
        v_character.state = 1  # 恢复掉线状态-> 正常状态
    else:
        v_character = VirtualCharacter(user.user_id, dynamic_id)
        VCharacterManager().add_character(v_character)

    now_node = v_character.node
    if not now_node:
        now_node = SceneSerManager().get_best_sceneid()
        if not now_node:
            logger.error("can't find game server!")
            return {'result': False, 'result_no': 4002}
        v_character.node = now_node

    # game服登录
    child_node = GlobalObject().child(now_node)
    res_data = child_node.enter_scene_remote(dynamic_id, user.user_id, pay_arg)
    if not res_data['player_data']:
        logger.error("enter scene error!")
        return {'result': False, 'result_no': 4003}
    if res_data['player_data'] == 4005:
        logger.debug("enter scene error, 4005!")
        VCharacterManager().drop_by_dynamic_id(dynamic_id)
        return {'result': False, 'result_no': 4005}

    # logger.debug("pull_message_remote")
    # # pull message from transit
    # GlobalObject().remote['transit'].pull_message_remote(user.user_id)

    SceneSerManager().add_client(now_node, dynamic_id)

    res_data['result'] = True
    return res_data
