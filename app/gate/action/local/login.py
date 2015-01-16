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


@local_service_handle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录 """
    argument = game_pb2.GameLoginRequest()
    argument.ParseFromString(request_proto)

    data = __character_login(dynamic_id)

    response = game_pb2.GameLoginResponse()

    if not data.get('result', True):
        response.res.result = False
        return response.SerializePartialToString()
    player_data = data.get('player_data')
    response.ParseFromString(player_data)

    argument.plat_id = 0
    argument.client_version = '0.0.0.1'
    argument.system_software = '1.1'
    argument.system_hardware = '2.2'
    argument.telecom_oper = 'tx'
    argument.network = 'wifi'
    argument.screen_width = 1024
    argument.screen_hight = 2048
    argument.density = 256
    argument.login_channel = 512
    argument.mac = '1.1.1'
    argument.cpu_hardware = 'intel'
    argument.memory = 1024
    argument.gl_render = 'abc'
    argument.gl_version = 'abcd'
    argument.device_id = '1x2y'

    tlog_action.log('PlayerLogin', response, argument)
    if data.get('is_new_character'):
        tlog_action.log('PlayerRegister', response, argument)

    nickname = response.nickname
    if nickname:
        # 聊天室登录
        GlobalObject().child('chat').login_chat_remote(dynamic_id,
                                                       response.id,
                                                       nickname,
                                                       response.guild_id)
    return response.SerializePartialToString()


def __character_login(dynamic_id):

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    logger.info("user_id:%d", dynamic_id)
    if not user:
        return {'result': False}

    v_character = VCharacterManager().get_by_id(user.user_id)
    if v_character:
        v_character.dynamic_id = dynamic_id
    else:
        v_character = VirtualCharacter(user.user_id, dynamic_id)
        VCharacterManager().add_character(v_character)

    now_node = SceneSerManager().get_best_sceneid()

    # game服登录
    child_node = GlobalObject().child(now_node)
    res_data = child_node.enter_scene_remote(dynamic_id, user.user_id)
    if not res_data['player_data']:
        return {'result': False}
    v_character.node = now_node

    logger.debug("pull_message_remote")
    # pull message from transit
    GlobalObject().remote['transit'].pull_message_remote(user.user_id)

    SceneSerManager().add_client(now_node, dynamic_id)

    res_data['result'] = True
    return res_data
