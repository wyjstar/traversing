# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

import datetime
from app.game.logic.common.check import have_player
from app.game.redis_mode import tb_character_friend
from app.game.core.PlayersManager import PlayersManager


def is_friend(player, friend_id):
    player_data = tb_character_friend.getObjData(player.base_info.id)
    # no friend records
    if not player_data:
        return False  # no friends data

    player_friends = player_data.get('friends')
    if not friend_id in player_friends:
        return False  # there is no friend with id
    return True


def is_exist_in_black_list(player, target_id):
    player_data = tb_character_friend.getObjData(player.base_info.id)
    # no friend records
    if not player_data:
        return False  # no friends data

    player_blacklist = player_data.get('blacklist')
    if not target_id in player_blacklist:
        return False  # there is no player in black list
    return True


@have_player
def add_friend_request(dynamic_id, invitee_id, **kwargs):
    """
    add inviter id to invitee's applicants list
    :param dynamic_id:
    :param inviter_id:
    :return:
    """
    player = kwargs.get('player')

    invitee_player = PlayersManager().get_player_by_id(invitee_id)
    if not invitee_player:
        return 1  # 'invitee is not exist'

    invitee_data = tb_character_friend.getObjData(invitee_id)
    if not invitee_data:
        data = {'id': invitee_id, 'friends': [], 'blacklist': [], 'applicants_list': {}}
        tb_character_friend.new(data)

    invitee_data = tb_character_friend.getObjData(invitee_id)
    invitee_applicants = invitee_data.get('applicants_list')
    if player.base_info.id in invitee_applicants.keys():
        return 2  # re-invite"

    invitee_applicants[player.base_info.id] = datetime.datetime.now()
    invitee_obj = tb_character_friend.getObj(invitee_id)
    invitee_obj.update('applicants_list', invitee_applicants)

    # todo sendto target message of friend application

    return 0  # jsuccess"


@have_player
def become_friends(dynamic_id, inviter_id, **kwargs):
    """
    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')

    invitee_data = tb_character_friend.getObjData(player.base_info.id)
    # no invite record
    if not invitee_data:
        return 1  # no applicant data

    # error inviter not exit in applicant list
    invitee_applicants = invitee_data.get('applicants_list')
    if not inviter_id in invitee_applicants.keys():
        return 2  # inviter id is not exit in applicants

    invite_time = invitee_applicants[inviter_id]
    period = datetime.datetime.now() - invite_time

    # remove inviter id from invitee's applicant list
    del(invitee_applicants[inviter_id])
    player_friend_obj = tb_character_friend.getObj(player.base_info.id)
    player_friend_obj.update('applicants_list', invitee_applicants)

    # inviting time is expired
    if period.days > 2:
        return 3  # period of between invited time and now is over 2 days

    inviter_data = tb_character_friend.getObjData(inviter_id)
    if not inviter_data:
        data = {'id': inviter_id, 'friends': [], 'blacklist': [], 'applicants_list': {}}
        tb_character_friend.new(data)

    # add both id in friend_list
    player_friend_data = tb_character_friend.getObjData(player.base_info.id)
    player_friends = player_friend_data.get('friends')
    player_friends.append(inviter_id)
    player_friend_obj = tb_character_friend.getObj(player.base_info.id)
    player_friend_obj.update('friends', player_friends)

    player_friend_data = tb_character_friend.getObjData(inviter_id)
    player_friends = player_friend_data.get('friends')
    player_friends.append(player.base_info.id)
    player_friend_obj = tb_character_friend.getObj(inviter_id)
    player_friend_obj.update('friends', player_friends)

    return 0


@have_player
def refuse_invition(dynamic_id, inviter_id, **kwargs):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')

    invitee_data = tb_character_friend.getObjData(player.base_info.id)
    # no invite record
    if not invitee_data:
        return 1  # no applicant data

    # error inviter not exit in applicant list
    invitee_applicants = invitee_data.get('applicants_list')
    if not inviter_id in invitee_applicants.keys():
        return 2  # inviter id is not exit in applicants

    # remove inviter id from invitee's applicant list
    del(invitee_applicants[inviter_id])
    player_friend_obj = tb_character_friend.getObj(player.base_info.id)
    player_friend_obj.update('applicants_list', invitee_applicants)

    return 0


@have_player
def del_friend(dynamic_id, friend_id, **kwargs):
    """

    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')

    if not is_friend(player, friend_id):
        return 1  # there is no friend with friend id

    # remove friend id from friend list
    player_data = tb_character_friend.getObjData(player.base_info.id)
    player_friends = player_data.get('friends')

    del(player_friends[friend_id])
    player_friends_obj = tb_character_friend.getObj(player.base_info.id)
    player_friends_obj.update('friends', player_data)

    return 0


@have_player
def add_player_to_blacklist(dynamic_id, target_id, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    player = kwargs.get('player')

    if is_exist_in_black_list(player, target_id):
        return 1  # target is already exist in black list


    return 0


def del_player_from_blacklist(dynamic_id, target_id):
    return 0

