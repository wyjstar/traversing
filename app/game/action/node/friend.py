# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.logic.friend import *


@remote_service_handle
def add_friend_request_1000(dynamic_id, target_id):
    """
    request to invite target as friend
    :param dynamic_id:
    :param target_id:
    :return:
    """

    return add_friend_request(dynamic_id, target_id)


@remote_service_handle
def add_friend_respond_accept_1001(dynamic_id, target_id):
    """
    respond to inviter
    :param target_id:
    :param dynamic_id: inviter id
    :param target_id: target id
    :return:
    """
    return become_friends(dynamic_id, target_id)


@remote_service_handle
def add_friend_respond_refuse_1002(dynamic_id, inviter_id):
    """
    refuse inviting
    :param dynamic_id:
    :param inviter_id:
    """
    return refuse_invition(dynamic_id, inviter_id)


@remote_service_handle
def del_friend_request_1003(dynamic_id, friend_id):
    """
    delete friend from friend list
    :param dynamic_id:
    :param target_id:
    """
    return del_friend(dynamic_id, friend_id)


@remote_service_handle
def add_black_list_1004(dynamic_id, target_id):
    """
    add a player to blacklist by id
    :param dynamic_id:
    :param target_id:
    """
    return add_player_to_blacklist(dynamic_id, target_id)


@remote_service_handle
def del_black_list_1005(dynamic_id, target_id):
    """
    delete a player from blacklist
    :param dynamic_id:
    :param target_id:
    """
    return del_player_from_blacklist(dynamic_id, target_id)
