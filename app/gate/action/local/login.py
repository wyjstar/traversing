# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午12:11.
"""
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.core.user import User
from app.gate.core.users_manager import UsersManager
from app.gate.proto_file import game_pb2
from app.gate.redis_mode import tb_account_mapping
from app.gate.service.local.gateservice import localservicehandle
from app.gate.core.virtual_character import VirtualCharacter
from app.gate.core.character_manager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject


@localservicehandle
def character_login_4(key, dynamic_id, request_proto):
    """角色登录
    @return:
    """

    argument = game_pb2.GameLoginResquest()
    argument.ParseFromString(request_proto)
    token = argument.token

    result = __character_login(dynamic_id, token)

    argument = game_pb2.GameLoginResponse()
    argument.result = result.get('result')
    argument.nickname = result.get('nickname')

    print '111111111111111111'
    print argument

    return argument.SerializePartialToString()


def __character_login(dynamic_id, token):
    account_id = None
    mapping_data = tb_account_mapping.getObjData(token)
    if mapping_data:
        account_id = mapping_data.get('id', None)  # 取得帐号ID

    print 'account_id:', account_id
    if not account_id:
        return {'result': False, 'nickname': ''}

    user = UsersManager().get_by_id(account_id)
    if user:
        user.dynamic_id = dynamic_id
    else:
        user = User(token, dynamic_id)
        user.init_user()

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

    nickname = character_info.get('nickname')

    GlobalObject().root.callChild(now_node, 601, dynamic_id, user.user_id)

    return {'result': True, 'nickname': nickname}