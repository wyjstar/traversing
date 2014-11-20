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

    # TODO 需要修改
    if response.guild_id:
        guild_id = response.guild_id
    else:
        guild_id = 0
    nickname = response.nickname
    if nickname:
        # TODO 起名时候
        # 聊天室登录
        GlobalObject().child('chat').login_chat_remote(dynamic_id,
                                                       response.id,
                                                       nickname,
                                                       guild_id)
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
    player_data = child_node.enter_scene_remote(dynamic_id, user.user_id)
    if not player_data:
        return {'result': False}
    v_character.node = now_node

    # pull message from transit
    GlobalObject().remote['transit'].pull_message_remote(user.user_id)

    SceneSerManager().add_client(now_node, dynamic_id)

    return {'result': True, 'player_data': player_data}
