# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""
import datetime

from app.game.action.root.netforwarding import push_message, push_object
from app.game.component.mail.mail import MailComponent
from app.game.core.PlayersManager import PlayersManager
from app.game.core.fight.battle_unit import BattleUnit
from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_character_info, tb_character_lord
from app.proto_file import friend_pb2
from app.proto_file.common_pb2 import CommonResponse
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger


@have_player
def add_friend_request(data, player):
    """
    add inviter id to invitee's applicants list
    :param dynamic_id:
    :param inviter_id:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    if len(request.target_ids) < 1:
        response.result = False
        response.result_no = 5  # fail
        return response.SerializePartialToString()  # fail

    target_id = request.target_ids[0]

    if target_id == player.base_info.id:
        response.result = False  # cant invite oneself as friend
        response.result_no = 4  # fail
        return response.SerializePartialToString()  # fail

    invitee_player = PlayersManager().get_player_by_id(target_id)
    if invitee_player:
        if not invitee_player.friends.add_applicant(player.base_info.id):
            response.result = False
            response.result_no = 1  # fail
            return response.SerializePartialToString()  # fail
        
        response_another = CommonResponse()
        response_another.result = True
        
        push_object(1110, response_another.SerializePartialToString(), [invitee_player.dynamic_id])
        invitee_player.friends.save_data()
    else:
        if not push_message(1050, target_id, player.base_info.id):
            response.result = False
            response.result_no = 2
            return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()


@have_player
def add_friend_request_remote(is_online, target_id, player):
    result = player.friends.add_applicant(target_id)
    player.friends.save_data()
    return result


@have_player
def become_friends(data, player):
    """
    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    for target_id in request.target_ids:
        if not player.friends.add_friend(target_id):
            response.result = False
            continue

        # save data
        player.friends.save_data()

        inviter_player = PlayersManager().get_player_by_id(target_id)
        if inviter_player:
            if not inviter_player.friends.add_friend(player.base_info.id,
                                                     False):
                response.result = False

            # save data
            inviter_player.friends.save_data()
            player.friends.save_data()
        else:
            if not push_message(1051, target_id, player.base_info.id):
                response.result = False

        # response.result_no += 1
    return response.SerializePartialToString()


@have_player
def become_friends_remote(is_online, target_id, player):
    result = player.friends.add_friend(target_id, False)
    player.friends.save_data()
    return result


@have_player
def refuse_invitation(data, player):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)


    for target_id in request.target_ids:
        if not player.friends.del_applicant(target_id):
            response.result = False
        response.result_no += 1

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()


@have_player
def del_friend(data, player):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    for target_id in request.target_ids:
        if not player.friends.del_friend(target_id):
            response.result = False

        # save data
        player.friends.save_data()

        response.result = push_message(1052, target_id, player.base_info.id)
        response.result_no += 1

    return response.SerializePartialToString()


@have_player
def del_friend_remote(is_online, target_id, player):
    result = player.friends.del_friend(target_id)
    player.friends.save_data()
    return result


@have_player
def add_player_to_blacklist(data, player):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    for target_id in request.target_ids:
        if not player.friends.add_blacklist(target_id):
            response.result = False
        response.result_no += 1

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()


@have_player
def del_player_from_blacklist(data, player):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    for target_id in request.target_ids:
        if not player.friends.del_blacklist(target_id):
            response.result = False
        response.result_no += 1

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()

def _with_battle_info(response, pid):
    # 添加好友主将的属性
    lord_data = tb_character_lord.getObjData(pid)
    if lord_data:
        info = lord_data.get('attr_info', {})
        battle_unit = BattleUnit.loads(info.get('info'))
        response.hero_no = battle_unit.no
        response.power = int(info.get('power', 0))
        response.hp = battle_unit.hp
        response.atk = battle_unit.atk
        response.physical_def = battle_unit.physical_def
        response.magic_def = battle_unit.magic_def

@have_player
def get_player_friend_list(player):
    response = friend_pb2.GetPlayerFriendsResponse()
    response.open_receive = player.stamina._open_receive
    

    for pid in player.friends.friends + [player.base_info.id]:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_friend_add = response.friends.add()
            response_friend_add.id = pid
            response_friend_add.nickname = player_data.get('nickname')
            response_friend_add.gift = player.friends.last_present_times(pid)

            # 添加好友主将的属性
            _with_battle_info(response_friend_add, pid)
        else:
            logger.error('get_player_friend_list, cant find player id:%d' % pid)

    for pid in player.friends.blacklist:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_blacklist_add = response.blacklist.add()
            response_blacklist_add.id = pid
            response_blacklist_add.nickname = player_data.get('nickname')
            response_blacklist_add.gift = 0

            # 添加好友主将的属性
            _with_battle_info(response_blacklist_add, pid)
        else:
            logger.error('get_player_friend_list, cant find player id:%d' % pid)

    for pid in player.friends.applicant_list:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_applicant_list_add = response.applicant_list.add()
            response_applicant_list_add.id = pid
            response_applicant_list_add.nickname = player_data.get('nickname')
            response_applicant_list_add.gift = 0

            # 添加好友主将的属性
            _with_battle_info(response_applicant_list_add, pid)
        else:
            logger.error('get_player_friend_list, cant find player id:' % pid)

    return response.SerializePartialToString()


@have_player
def find_friend_request(data, **kwargs):
    """

    :param dynamic_id:
    :param data:
    :param kwargs:
    :return:
    """
    request = friend_pb2.FindFriendRequest()
    request.ParseFromString(data)

    response = friend_pb2.FindFriendResponse()
    response.id = 0
    response.nickname = '?'
    response.atk = 0
    response.hero_no = 0
    response.gift = 0

    if request.id_or_nickname.isdigit():
        player_data = tb_character_info.getObjData(request.id_or_nickname)
    else:
        player_data = util.GetOneRecordInfo('tb_character_info', dict(nickname=request.id_or_nickname))
    
    if player_data:
        pid = player_data.get('id')
        nickname = player_data.get('nickname')
        response.id = pid
        response.nickname = nickname
        
        # 添加好友主将的属性
        _with_battle_info(response, pid)

    return response.SerializePartialToString()

@have_player
def open_friend_receive(data, player):
    response = CommonResponse()
    player.stamina.open_receive()
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()

@have_player
def close_friend_receive(data, player):
    response = CommonResponse()
    player.stamina.close_receive()
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()

@have_player
def given_stamina(data, player):
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)
    target_id = request.target_ids[0]

    success = player.friends.given_stamina(target_id)
    if not success:
        response.result = False
        response.result_no = 1  # fail
        return response.SerializePartialToString()  # fail
    player.friends.save_data()
    return response.SerializePartialToString()  # fail

@have_player
def make_chat_mail(data, player):
    """生成私聊邮件"""
    request = friend_pb2.FriendPrivateChatRequest()
    request.ParseFromString(data)
    target_id = request.target_uid
    content = request.content
    
    title_display_len = 10
    if len(content) <= title_display_len:
        title = content
    else:
        title = content[:title_display_len] + "..."
    
    mail = {'sender_id': player.base_info.id,
            'sender_name': player.base_info.base_name,
            'sender_icon': player.line_up_component.lead_hero_no,
            'receive_id': target_id,
            'receive_name': '0',
            'title': title,
            'content': content,
            'mail_type': MailComponent.TYPE_MESSAGE,
            'prize': 0}
    return mail
