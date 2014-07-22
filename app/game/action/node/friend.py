# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.core.PlayersManager import PlayersManager
from app.game.core.friend import *


@remote_service_handle
def add_friend_request_1(dynamic_id, target_id):
    """
    request to invite target as friend
    :param dynamic_id:
    :param target_id:
    :return:
    """
    target = PlayersManager().get_player_by_id(target_id)
    if not target:
        return 'target is not exist'

    add_friend_request(dynamic_id, target_id)

    # todo sendto target message of friend application

    return "success"


@remote_service_handle
def add_friend_respond_accept_2(dynamic_id, target_id):
    """
    respond to inviter
    :param target_id:
    :param dynamic_id: inviter id
    :param target_id: target id
    :return:
    """
    return become_friends(dynamic_id, target_id)


@remote_service_handle
def add_friend_respond_refuse_3(dynamic_id, inviter_id):
    """
    refuse inviting
    :param dynamic_id:
    :param inviter_id:
    """
    dynamic_id
    inviter_id
    # todo sendto inviter refuse message
    pass


@remote_service_handle
def del_friend_request_4(dynamic_id, target_id):
    """

    :param dynamic_id:
    :param target_id:
    """
    dynamic_id
    target_id
    pass


@remote_service_handle
def add_black_list_5(dynamic_id, target_id):
    """

    :param dynamic_id:
    :param target_id:
    """
    dynamic_id
    target_id
    pass


@remote_service_handle
def del_black_list_6(dynamic_id, target_id):
    """

    :param dynamic_id:
    :param target_id:
    """
    dynamic_id
    target_id
    pass
