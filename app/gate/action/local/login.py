# -*- coding:utf-8 -*-
"""
created by wzp on 14-6-19下午12:11.
"""
from app.gate.service.local.gateservice import localservicehandle
import json
from app.gate.model import dbcharacter
from shared.utils import const
from app.gate.core.virtualcharacter import VirtualCharacter
from app.gate.core.charactermanager import VCharacterManager
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.scenesermanger import SceneSerManager
from app.gate.model import dbuser
from gtwisted.utils import log


@localservicehandle
def character_login_4(key, dynamicid, request_proto):
    """角色登录
    :return:
    """

    args = json.loads(request_proto)
    token = args.get('token')
    log.msg(token, "++++++++++++++++++++++++++++++")
    data = character_login(dynamicid, token)

    if not data.get('result'):
        return json.dumps(data)
    log.msg("token is correct+++++++++++++++++++++++++++++++++++++")
    response = enter_scene(dynamicid)  # 登录成功，进入场景


    return response  # 进入场景后，返回消息


def character_login(dynamicid, token):

    userinfo = dbuser.get_userinfo_by_token(token)
    if not userinfo:
        return {'result': False, 'message': u'token_error'}

    characterinfo = dbcharacter.get_character_by_userid(userinfo['userid'])
    if not characterinfo:
        return {'result': False, 'message': u'no_role'}

    old_character = VCharacterManager().get_character_by_characterid(characterinfo['id'])
    if old_character:
        old_character.dynamicid = dynamicid
    else:
        character = VirtualCharacter(characterinfo['id'], dynamicid)
        VCharacterManager().add_character(character)

    return {'result': True, 'message': u'login_success', 'data': characterinfo}


def enter_scene(dynamicid):
    """进入场景
    @param dynamicid: int 客户端的ID
    """
    vplayer = VCharacterManager().get_character_by_clientid(dynamicid)
    if not vplayer:
        return None
    currentnode = SceneSerManager().get_best_sceneid()
    response = GlobalObject().root.callChild(currentnode, 601, dynamicid)
    vplayer.node = currentnode
    SceneSerManager().add_client(currentnode, vplayer.dynamicid)
    return response


def return_message(result):
    return json.dump(result)

