# -*- coding:utf-8 -*-
"""
created by server on 14-5-20下午8:33.
"""
import time
from app.chat.core.chater_manager import ChaterManager
from app.chat.service.node.chatgateservice import nodeservice_handle
from app.proto_file import chat_pb2
from app.chat.service.node.chatgateservice import noderemote
from shared.utils import trie_tree
from shared.db_opear.configs_data import game_configs
from gfirefly.dbentrust.redis_mode import RedisObject
#from shared.common_logic.feature_open import is_open, CHAT


tb_character_info = RedisObject('tb_character_info')


@nodeservice_handle
def send_message_1002(character_id, dynamic_id, room_id, content,
                      character_nickname, to_character_id,
                      to_character_nickname, guild_id, vip_level,
                      guild_position):
    """发送信息
    @param character_nickname: 角色昵称
    @param to_character_id: 私聊对象角色id
    @param to_character_nickname: 私聊对象角色昵称
    @param dynamic_id: int 客户端的id
    @param character_id: int角色的id
    @param room_id: int 聊天频道
    @param content: str 聊天内容
    """

    chater = ChaterManager().getchater_by_id(character_id)
    #if is_open(CHAT, chater):
        #return {'result': False, 'result_no': 837}
    ids = []
    if not chater:
        # TODO message 信息要补充
        return {'result': False, 'result_no': 800}

    if chater.gag_time > int(time.time()) or chater.gag_time == -2:
        return {'result': False, 'result_no': 836, 'gag_time': chater.gag_time}  # 已被禁言

    if content:
        content1 = trie_tree.check.replace_bad_word(content.encode("utf-8"))
    if content != content1:
        if chater.say_bad_words_times()+1 >= game_configs.base_config.get('StopTalkNeedTimes'):
            chater.clear_say_bad_words()
            gag_time = int(time.time()) + game_configs.base_config.get('StopTalkTime')*60
            chater.gag_time = gag_time
            char_obj = tb_character_info.getObj(character_id)
            char_obj.hset('gag', gag_time)
            content = content1
        else:
            content = content1
            chater.say_bad_words_once()

    if room_id == 1:  # 世界聊天频道
        last_time = chater.last_time
        if int(time.time()) - last_time < game_configs.base_config.get('chat_interval'):
            return {'result': False, 'result_no': 806}  # 60秒内不可聊天

        ids = ChaterManager().getall_dynamicid()
        response = chat_pb2.chatMessageResponse()
        response.time = int(time.time())
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        owner.vip_level = vip_level
        response.content = content
        chater.last_time = int(time.time())
        noderemote.push_object_remote(1000, response.SerializeToString(), ids)

    elif room_id == 3:  # 私聊频道
        other_chater = ChaterManager().getchater_by_id(to_character_id)
        if not other_chater:
            return {'result': False}
        response = chat_pb2.chatMessageResponse()
        response.time = int(time.time())
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        owner.vip_level = vip_level
        response.content = content
        noderemote.push_object_remote(1000, response.SerializeToString(),
                                      [other_chater.dynamic_id])

    elif room_id == 2:  # 公会频道
        ids = ChaterManager().get_guild_dynamicid(guild_id)
        if ids.count(dynamic_id) != 1:
            return {'result': False}
        response = chat_pb2.chatMessageResponse()
        response.time = int(time.time())
        response.channel = room_id
        owner = response.owner
        owner.id = character_id
        owner.nickname = character_nickname
        owner.vip_level = vip_level
        owner.guild_position = guild_position
        response.content = content
        noderemote.push_object_remote(1000, response.SerializeToString(), ids)

    return {'result': True}
