# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.friend import *


@remote_service_handle
def add_friend_request_1100(dynamic_id, data):
    """
    request to invite target as friend
    :param dynamic_id:
    :param target_id:
    :return:
    """

    return add_friend_request(dynamic_id, data)


@remote_service_handle
def add_friend_respond_accept_1101(dynamic_id, data):
    """
    respond to inviter
    :param target_id:
    :param dynamic_id: inviter id
    :param target_id: target id
    :return:
    """
    return become_friends(dynamic_id, data)


@remote_service_handle
def add_friend_respond_refuse_1102(dynamic_id, data):
    """
    refuse inviting
    :param dynamic_id:
    :param inviter_id:
    """
    return refuse_invitation(dynamic_id, data)


@remote_service_handle
def del_friend_request_1103(dynamic_id, data):
    """
    delete friend from friend list
    :param dynamic_id:
    :param target_id:
    """
    return del_friend(dynamic_id, data)


@remote_service_handle
def add_black_list_1104(dynamic_id, data):
    """
    add a player to blacklist by id
    :param dynamic_id:
    :param target_id:
    """
    return add_player_to_blacklist(dynamic_id, data)


@remote_service_handle
def del_black_list_1105(dynamic_id, data):
    """
    delete a player from blacklist
    :param dynamic_id:
    :param target_id:
    """
    return del_player_from_blacklist(dynamic_id, data)


@remote_service_handle
def get_player_friend_list_1106(dynamic_id, data):
    import traceback
    traceback.print_stack()
    return get_player_friend_list(dynamic_id)


@remote_service_handle
def find_friend_request_1107(dynamic_id, data):
    return find_friend_request(dynamic_id, data)