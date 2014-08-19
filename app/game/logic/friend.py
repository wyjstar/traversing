# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""
import datetime

from app.game.logic.common.check import have_player
from app.game.core.PlayersManager import PlayersManager
from app.game.core.offline.friend_offline import FriendOffline
from app.game.redis_mode import tb_nickname_mapping, tb_character_info
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file.friend_pb2 import *
from app.game.action.root.netforwarding import push_object, push_message


@have_player
def add_friend_request(dynamic_id, data, **kwargs):
    """
    add inviter id to invitee's applicants list
    :param dynamic_id:
    :param inviter_id:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    if len(request.target_ids) < 1:
        response.result = False
        response.result_no = 5  # fail
        print 'add_friend_request target_ids less one!'
        return response.SerializePartialToString()  # fail

    target_id = request.target_ids[0]

    player = kwargs.get('player')
    if target_id == player.base_info.id:
        response.result = False  # cant invite oneself as friend
        response.result_no = 4  # fail
        print 'add_friend_request cant add oneself as friend! self:%d target:%d'\
              % (player.base_info.id, target_id)
        return response.SerializePartialToString()  # fail

    invitee_player = PlayersManager().get_player_by_id(target_id)
    if invitee_player:
        if not invitee_player.friends.add_applicant(player.base_info.id):
            response.result = False
            response.result_no = 1  # fail
            return response.SerializePartialToString()  # fail

        push_object(1010, player.base_info.id, invitee_player.dynamic_id)
        invitee_player.friends.save_data()
    else:
        push_message(10000, target_id, 1, 2, 3, 'a', 'b')
        friend_offline = FriendOffline(target_id)
        if not friend_offline.add_applicant(player.base_info.id):
            response.result = False
            response.result_no = 2  # offline fail
            return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()


@have_player
def become_friends(dynamic_id, data, **kwargs):
    """
    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.target_ids:
        if not player.friends.add_friend(target_id):
            response.result = False
            print 'player add friend fail'
            continue

        # save data
        player.friends.save_data()

        inviter_player = PlayersManager().get_player_by_id(target_id)
        if inviter_player:
            if not inviter_player.friends.add_friend(player.base_info.id, False):
                response.result = False
                print 'inviter add friend fail'

        # save data
            inviter_player.friends.save_data()
            player.friends.save_data()
        else:
            friend_offline = FriendOffline(target_id)
            if not friend_offline.add_friend(player.base_info.id):
                response.result = False
                print 'offline player add friend fail'

        # response.result_no += 1
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
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.targett_ids:
        if not player.friends.del_applicant(target_id):
            response.result = False
        response.result_no += 1

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
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.target_ids:
        if not player.friends.del_friend(target_id):
            response.result = False

        # save data
        player.friends.save_data()

        friend_player = PlayersManager().get_player_by_id(target_id)
        if friend_player:
            if not friend_player.friends.del_friend(player.base_info.id):
                response.result = False
        else:
            friend_offline = FriendOffline(target_id)
            if not friend_offline.del_friend(player.base_info.id):
                response.result = False
        response.result_no += 1

    return response.SerializePartialToString()


@have_player
def add_player_to_blacklist(dynamic_id, data, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.target_ids:
        if not player.friends.add_blacklist(target_id):
            response.result = False
        response.result_no += 1

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
    response.result = True
    response.result_no = 0
    request = FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.target_ids:
        if not player.friends.del_blacklist(target_id):
            response.result = False
        response.result_no += 1

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
            response_friend_add.ap = 999
            response_friend_add.icon_id = 99
            response_friend_add.gift = datetime.datetime.now().day
        else:
            print 'get_player_friend_list', 'cant find player id:', pid

    for pid in player.friends.blacklist:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_blacklist_add = response.blacklist.add()
            response_blacklist_add.player_id = pid
            response_blacklist_add.nickname = player_data.get('nickname')
            response_blacklist_add.ap = 888
            response_blacklist_add.icon_id = 88
            response_blacklist_add.gift = datetime.datetime.now().day
        else:
            print 'get_player_friend_list', 'cant find player id:', pid

    for pid in player.friends.applicant_list:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_applicant_list_add = response.applicant_list.add()
            response_applicant_list_add.player_id = pid
            response_applicant_list_add.nickname = player_data.get('nickname')
            response_applicant_list_add.ap = 666
            response_applicant_list_add.icon_id = 66
            response_applicant_list_add.gift = datetime.datetime.now().day
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
    request = FindFriendRequest()
    request.ParseFromString(data)

    response = FindFriendResponse()
    response.id = 0
    response.nickname = 'none'
    response.ap = 111
    response.icon_id = 11
    response.gift = datetime.datetime.now().day

    if request.id_or_nickname.isdigit():
        player_data = tb_character_info.getObjData(request.id_or_nickname)
        if player_data:
            response.id = player_data.get('id')
            response.nickname = player_data.get('nickname')
    else:
        player_data = tb_nickname_mapping.getObjData(request.id_or_nickname)
        if player_data:
            response.id = player_data.get('id')
            response.nickname = player_data.get('nickname')

    return response.SerializePartialToString()
