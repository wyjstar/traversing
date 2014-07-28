# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午12:11.
"""
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.core.users_manager import UsersManager
from app.gate.service.local.gateservice import local_service_handle
from app.gate.core.virtual_character import VirtualCharacter
from app.gate.core.virtual_character_manager import VCharacterManager
from app.proto_file import player_request_pb2
from gfirefly.server.globalobject import GlobalObject
from app.proto_file import game_pb2


@local_service_handle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录
    @return:
    """

    argument = player_request_pb2.PlayerLoginResquest()
    argument.ParseFromString(request_proto)
    token = argument.token

    result = __character_login(dynamic_id, token)
    print 'result:', result
    argument = game_pb2.GameLoginResponse()
    argument.result = result.get('result')

    nickname = result.get('nickname', None)
    if nickname:
        argument.nickname = nickname
        #TODO 起名时修改昵称登录
        # 聊天室登录
        GlobalObject().root.callChild('chat', 1001, result.get('character_id'), dynamic_id, nickname)
    return argument.SerializePartialToString()


def enter_scene(dynamic_id):
    now_node = SceneSerManager().get_best_sceneid()
    return GlobalObject().root.callChild(now_node, 601, dynamic_id, 1)


def __character_login(dynamic_id, token):

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    if not user:
        return {'result': False}

    character_info = user.character

    # TODO 校验character_info 和  user 中id 是否相同

    v_character = VCharacterManager().get_by_id(user.user_id)
    if v_character:
        v_character.dynamic_id = dynamic_id
    else:
        v_character = VirtualCharacter(user.user_id, dynamic_id)
        VCharacterManager().add_character(v_character)

    now_node = SceneSerManager().get_best_sceneid()

    # game服登录
    GlobalObject().root.callChild(now_node, 601, dynamic_id, user.user_id)
    v_character.node = now_node
    SceneSerManager().add_client(now_node, dynamic_id)

    return {'result': True, 'nickname': character_info.get('nickname'), 'character_id': character_info.get('id')}


