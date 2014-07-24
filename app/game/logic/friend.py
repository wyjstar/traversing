# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""

from app.game.logic.common.check import have_player
from app.game.core.PlayersManager import PlayersManager


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

    if invitee_player:
        if not invitee_player.friends.add_applicant(player.base_info.id):
            return 1  # fail
    else:
        # todo sendto target message of friend application
        pass

    invitee_player.friends.save_data()

    return 0  # fail


@have_player
def become_friends(dynamic_id, inviter_id, **kwargs):
    """
    :param dynamic_id:
    :param inviter_id:
    :param kwargs:
    :return:
    """
    player = kwargs.get('player')

    if not player.friends.is_in_applicants_list(inviter_id):
        return 1  # inviter id is not exit in applicants

    if not player.friends.del_applicant(inviter_id):
        return 2  # del applicant error

    inviter_player = PlayersManager().get_player_by_id(inviter_id)

    if inviter_player:
        if not inviter_player.friends.add_friend(player.base_info.id):
            return 3
        if not player.friends.add_friend(inviter_id):
            return 3

        # save data
        inviter_player.friends.save_data()
        player.friends.save_data()
    else:
        # todo modify offline data
        pass

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

    if not player.friends.is_in_applicants_list(inviter_id):
        return 1
    if not player.friends.del_applicant(inviter_id):
        return 2

    # save data
    player.friends.save_data()
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

    if not player.friends.is_friend(friend_id):
        return 1  # there is no friend with friend id

    if not player.friends.del_friend(friend_id):
        return 2

    # save data
    player.friends.save_data()
    return 0


@have_player
def add_player_to_blacklist(dynamic_id, target_id, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    player = kwargs.get('player')

    if player.friends.is_in_blacklist(target_id):
        return 1  # already exist the player in blacklist

    if not player.friends.add_blacklist(target_id):
        return 2

    # save data
    player.friends.save_data()
    return 0


@have_player
def del_player_from_blacklist(dynamic_id, target_id, **kwargs):
    """

    :param dynamic_id:
    :param target_id:
    :return:
    """
    player = kwargs.get('player')

    if not player.friends.is_in_blacklist(target_id):
        return 1  # not exist the player in blacklist

    if not player.friends.del_blacklist(target_id):
        return 2

    # save data
    player.friends.save_data()
    return 0

