# -*- coding:utf-8 -*-
"""
created by server on 14-6-20上午11:49.
"""
from app.gate.service.local.gateservice import localservicehandle
from app.gate.model import dbcharacter
from app.gate.model import dbuser
from enterscene import enter_scene
from gtwisted.utils import log
import json
from app.gate.core.virtual_character import VirtualCharacter
from app.gate.core.character_manager import VCharacterManager


@localservicehandle
def create_character_5(key, dynamicid, request_proto):
    """创建角色
    arguments=(userId,nickName)
    userId用户ID
    nickName角色昵称
    """
    data = json.loads(request_proto)
    token = data.get('token')
    nickname = data.get('nickname')
    log.msg('token', token)
    log.msg('nickname', nickname)
    userinfo = dbuser.get_userinfo_by_token(token)
    result = create_character(userinfo['userid'], nickname)

    if result.get('result') == 0:
        return result
    log.msg('result', result.get('result'), dynamicid)
    # save character
    character = VirtualCharacter(result.get('characterid'), dynamicid)
    VCharacterManager().add_character(character)
    # enter scene
    response = enter_scene(dynamicid)  # 登录成功，进入场景
    return response  # 进入场景后，返回消息


def create_character(userid, nickname):
    characterid = dbcharacter.create_character(userid, nickname)
    log.msg(characterid, 'finish insert character+++++++++++++++++++++++++++++++++')

    if not characterid:
        return {'result': 0, 'message': u'insert character error!'}
    return {'result': 1, 'message': u'insert character success!'}