# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午12:11.
"""
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.core.users_manager import UsersManager
from app.gate.redis_mode import tb_nickname_mapping
from app.gate.service.local.gateservice import local_service_handle
from app.gate.core.virtual_character import VirtualCharacter
from app.gate.core.virtual_character_manager import VCharacterManager
from app.proto_file import player_request_pb2
from gfirefly.server.globalobject import GlobalObject


@local_service_handle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录
    @return:
    """
    return enter_scene(dynamic_id)
    argument = player_request_pb2.PlayerLoginResquest()
    argument.ParseFromString(request_proto)
    token = argument.token

    result = __character_login(dynamic_id, token)

    argument = game_pb2.GameLoginResponse()
    argument.result = result.get('result')
    argument.nickname = result.get('nickname')

    print '111111111111111111'
    print argument

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
    v_character.node = now_node

    GlobalObject().root.callChild(now_node, 601, dynamic_id, user.user_id)

    return {'result': True, 'nickname': character_info.get('nickname')}


@local_service_handle
def nickname_create_5(key, dynamic_id, request_proto):
    argument = player_request_pb2.CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname
    result = __nickname_create(dynamic_id, nickname)

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    if not user:
        return {'result': False}

    character_info = user.character
    now_node = SceneSerManager().get_best_sceneid()

    return GlobalObject().root.callChild(now_node, 601, dynamic_id, user.user_id)


def __nickname_create(dynamic_id, nickname):
    user = UsersManager().get_by_dynamic_id(dynamic_id)
    if not user:
        return {'result': False, 'nickname': nickname}
    else:
        user.character = {'uid': user.user_id, 'nickname': nickname}

        print 'sadfasdfas:', user.character

        nickname_data = dict(id=user.user_id, nickname=nickname)
        nickname_mmode = tb_nickname_mapping.new(nickname_data)
        nickname_mmode.insert()

    return {'result': True, 'nickname': nickname}