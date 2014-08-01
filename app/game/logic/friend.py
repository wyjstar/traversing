# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

from app.game.logic.common.check import have_player
from app.game.core.PlayersManager import PlayersManager
from app.game.core.offline.friend_offline import FriendOffline
from app.game.redis_mode import tb_nickname_mapping, tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.friend_pb2 import *
from app.game.action.root.netforwarding import push_object


@have_player
def add_friend_request(dynamic_id, data, **kwargs):
    """
    add inviter id to invitee's applicants list
    :param dynamic_id:
    :param inviter_id:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')
    invitee_player = PlayersManager().get_player_by_id(request.target_id)

    if invitee_player:
        if not invitee_player.friends.add_applicant(player.base_info.id):
            response.result = 1  # fail
            return response.SerializePartialToString()  # fail

        push_object(1010, player.base_info.id, invitee_player.dynamic_id)
        invitee_player.friends.save_data()
    else:
        friend_offline = FriendOffline(request.target_id)
        if not friend_offline.add_applicant(player.base_info.id):
            response.result = 2  # offline fail
            return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()  # fail


@have_player
def become_friends(dynamic_id, data, **kwargs):
    """
    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    if not player.friends.is_in_applicants_list(request.target_id):
        response.result = 1  # inviter id is not exit in applicants
        return response.SerializePartialToString()

    if not player.friends.del_applicant(request.target_id):
        response.result = 2  # del applicant error
        return response.SerializePartialToString()

    if not player.friends.add_friend(request.target_id):
        response.result = 3
        return response.SerializePartialToString()

    # save data
    player.friends.save_data()

    inviter_player = PlayersManager().get_player_by_id(request.target_id)

    if inviter_player:
        if not inviter_player.friends.add_friend(player.base_info.id):
            response.result = 4
            return response.SerializePartialToString()

        # save data
        inviter_player.friends.save_data()
        player.friends.save_data()
    else:
        friend_offline = FriendOffline(request.target_id)
        if not friend_offline.add_friend(player.base_info.id):
            response.result = 5
            return response.SerializePartialToString()

    return response.SerializePartialToString()


@have_player
def refuse_invitation(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    if not player.friends.is_in_applicants_list(request.target_id):
        response.result = 1
        return response.SerializePartialToString()
    if not player.friends.del_applicant(request.target_id):
        response.result = 2
        return response.SerializePartialToString()

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()


@have_player
def del_friend(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    if not player.friends.is_friend(request.target_id):
        response.result = 1  # there is no friend with friend id
        return response.SerializePartialToString()

    if not player.friends.del_friend(request.target_id):
        response.result = 2
        return response.SerializePartialToString()

    # save data
    player.friends.save_data()

    friend_player = PlayersManager().get_player_by_id(request.target_id)
    if friend_player:
        if not friend_player.friends.is_friend(player.base_info.id):
            response.result = 3
            return response.SerializePartialToString()
        if not friend_player.friends.del_friend(player.base_info.id):
            response.result = 4
            return response.SerializePartialToString()
    else:
        friend_offline = FriendOffline(request.target_id)
        if not friend_offline.del_friend(player.base_info.id):
            response.result = 5
            return response.SerializePartialToString()

    return response.SerializePartialToString()


@have_player
def add_player_to_blacklist(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    if player.friends.is_in_blacklist(request.target_id):
        response.result = 1  # already exist the player in blacklist
        return response.SerializePartialToString()

    if not player.friends.add_blacklist(request.target_id):
        response.result = 2
        return response.SerializePartialToString()

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()


@have_player
def del_player_from_blacklist(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    response = CommonResponse()
    response.result = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    if not player.friends.is_in_blacklist(request.target_id):
        response.result = 1  # not exist the player in blacklist
        return response.SerializePartialToString()

    if not player.friends.del_blacklist(request.target_id):
        response.result = 2
        return response.SerializePartialToString()

    # save data
    player.friends.save_data()
    return response.SerializePartialToString()


@have_player
def get_player_friend_list(dynamic_id, **kwargs):

    response = GetPlayerFriendsResponse()
    player = kwargs.get('player')

    for pid in player.friends.friends:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_friend_add = response.friends.add()
            response_friend_add.player_id = pid
            response_friend_add.nickname = player_data.get('nickname')
        else:
            print 'get_player_friend_list', 'cant find player id:', pid

    for pid in player.friends.black_list:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_blacklist_add = response.blacklist.add()
            response_blacklist_add.player_id = pid
            response_friend_add.nickname = player_data.get('nickname')
        else:
            print 'get_player_friend_list', 'cant find player id:', pid

    for pid in player.friends.applicant_list:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_applicant_list_add = response.applicant_list.add()
            response_applicant_list_add.player_id = pid
            response_friend_add.nickname = player_data.get('nickname')
        else:
            print 'get_player_friend_list', 'cant find player id:', pid

    return response.SerializePartialToString()



@have_player
def find_friend_request(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param data:
    :param kwargs:
    :return:
    """
    response = FindFriendRequest()
    response.result = 0
    request = FindFriendResponse()
    request.ParseFromString(data)

    response.id = 0
    response.nickname = 'none'

    if request.id_or_nickname.isdigit():
        player_data = tb_character_info.getObjData(request.id_or_nick_name)
        if player_data:
            response.id = player_data.get('id')
            response.nickname = player_data.get('nickname')
    else:
        player_data = tb_nickname_mapping.getObjData(request.id_or_nickname)
        if player_data:
            response.id = player_data.get('id')
            response.nickname = player_data.get('nickname')

    return response.SerializePartialToString()
