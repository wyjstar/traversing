# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午5:12.
"""
import time
from app.game.action.root.netforwarding import login_chat

from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_nickname_mapping, tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.server.globalobject import GlobalObject
from shared.utils import trie_tree


@have_player
def nickname_create(dynamic_id, nickname, **kwargs):
    player = kwargs.get('player')
    response = CommonResponse()


    print type(nickname), "nickname++++++++++++++++++++++++++++"
    nickname = nickname.encode("utf-8")
    print type(nickname), "nickname2++++++++++++++++++++++++++++"

    # TODO 名字不合法 返回错误码
    print 'aaaaaaaaaaaaaaaaaaaaa', trie_tree.check.replace_bad_word(nickname).encode("utf-8"), nickname, type(nickname), type(trie_tree.check.replace_bad_word(nickname).encode("utf-8"))
    if trie_tree.check.replace_bad_word(nickname).encode("utf-8") != nickname:
        print 'bbbbbbbbbbbbbbbb', trie_tree.check.replace_bad_word(nickname).encode("utf-8"), nickname, type(nickname), type(trie_tree.check.replace_bad_word(nickname).encode("utf-8"))
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    # 判断昵称是否重复
    start_time = time.time()
    data = tb_nickname_mapping.getObjData(nickname)
    end_time = time.time()
    print 'command 5 :', end_time - start_time
    if data:
        response.result = False
        response.result_no = 1
        return response.SerializeToString()

    player.base_info.base_name = nickname
    nickname_data = dict(id=player.base_info.id, nickname=nickname)
    nickname_mmode = tb_nickname_mapping.new(nickname_data)
    nickname_mmode.insert()

    character_obj = tb_character_info.getObj(player.base_info.id)
    if not character_obj:
        response.result_no = 2
        return response.SerializeToString()
    character_obj.update('nickname', nickname)

    # 加入聊天
    login_chat(dynamic_id, player.base_info.id, player.guild.g_id, nickname)

    response.result = True
    return response.SerializeToString()
