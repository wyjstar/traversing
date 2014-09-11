# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午5:12.
"""

from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_nickname_mapping, tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.globalobject import GlobalObject


@have_player
def nickname_create(dynamic_id, nickname, **kwargs):
    player = kwargs.get('player')
    response = CommonResponse()
    # 判断昵称是否重复
    data = tb_nickname_mapping.getObjData(nickname)
    if data:
        response.result = False
        response.result_no = 1
        print 'the nickanme(%s) is used' % nickname
        return response.SerializeToString()

    nickname_data = dict(id=player.base_info.id, nickname=nickname)
    nickname_mmode = tb_nickname_mapping.new(nickname_data)
    nickname_mmode.insert()

    character_obj = tb_character_info.getObj(player.base_info.id)
    if not character_obj:
        print 'nickname create: cant find character info obj by id:', player.base_info.id
        response.result_no = 2
        return response.SerializeToString()
    character_obj.update('nickname', nickname)

    response.result = True
    return response.SerializeToString()
