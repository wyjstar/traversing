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
from enterscene import enter_scene
from app.gate.model import dbuser
from gtwisted.utils import log



@localservicehandle
def character_login_4(key, dynamicid, request_proto):
    """角色登录
    :return:
    """

    args = json.loads(request_proto)
    token = args.get('token')
    data = character_login(dynamicid, token)

    if not data.get('result'):
        return json.dumps(data)

    response = enter_scene(dynamicid)  # 登录成功，进入场景
    return response  # 进入场景后，返回消息


def character_login(dynamicid, token):

    userinfo = dbuser.get_userinfo_by_token(token)
    if not userinfo:
        return {'result': 0, 'message': u'token_error'}

    characterinfo = dbcharacter.get_character_by_userid(userinfo['userid'])
    if not characterinfo:
        log.msg('no_role+++++++++++++++++++++++++++++++')
        return {'result': 0, 'message': u'no_role'}

    old_character = VCharacterManager().get_character_by_characterid(characterinfo['id'])
    if old_character:
        old_character.dynamicid = dynamicid
    else:
        character = VirtualCharacter(characterinfo['id'], dynamicid)
        VCharacterManager().add_character(character)

    return {'result': True, 'message': u'login_success', 'data': characterinfo}

