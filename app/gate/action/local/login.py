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
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.player_request_pb2 import CreatePlayerRequest

@local_service_handle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录
    @return:
    """

    argument = game_pb2.GameLoginRequest()
    argument.ParseFromString(request_proto)
    token = argument.token

    response = __character_login(dynamic_id, token)

    nickname = response[0].nickname
    if nickname:
        #TODO 起名时候
        # 聊天室登录
        GlobalObject().root.callChild('chat', 1001, response[1], dynamic_id, nickname)
    return response[0].SerializePartialToString()


# def enter_scene(dynamic_id):
#     now_node = SceneSerManager().get_best_sceneid()
#
#     pull message from transit
    # vplayer = VCharacterManager().get_by_dynamic_id(dynamic_id)
    # GlobalObject().remote['transit'].callRemote("pull_message", vplayer.character_id)
    #
    # return GlobalObject().root.callChild(now_node, 601, dynamic_id, 1)


def __character_login(dynamic_id, token):

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    if not user:
        return {'result': False}

    character_info = user.character
    print 'character login nickname', character_info.get('nickname')

    # TODO 校验character_info 和  user 中id 是否相同

    v_character = VCharacterManager().get_by_id(user.user_id)
    if v_character:
        v_character.dynamic_id = dynamic_id
    else:
        v_character = VirtualCharacter(user.user_id, dynamic_id)
        VCharacterManager().add_character(v_character)

    now_node = SceneSerManager().get_best_sceneid()

    # game服登录
    player_data = GlobalObject().root.callChild(now_node, 601, dynamic_id, user.user_id)
    v_character.node = now_node

    # pull message from transit
    GlobalObject().remote['transit'].callRemote("pull_message", user.user_id)

    SceneSerManager().add_client(now_node, dynamic_id)

    print "login success++++++++++++++++++++++++++"
    response = game_pb2.GameLoginResponse()
    response.ParseFromString(player_data)
    return response, character_info.get('id')

@local_service_handle
def create_nickname_5(key, dynamic_id, request_proto):
    argument = CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname


    now_node = SceneSerManager().get_best_sceneid()
    info = GlobalObject().root.callChild(now_node, 5, dynamic_id, request_proto)

    response = CommonResponse()
    response.ParseFromString(info)

    user = UsersManager().get_by_dynamic_id(dynamic_id)

    if response.result and nickname:
        # 聊天室登录
        print '# chat login:', user.user_id, dynamic_id, nickname
        GlobalObject().root.callChild('chat', 1001, user.user_id, dynamic_id, nickname)

    return info



