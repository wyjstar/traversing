# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""
from app.game.logic import friend
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def add_friend_request_1100(dynamic_id, data):
    """ request to invite target as friend """
    return friend.add_friend_request(dynamic_id, data)


@remoteserviceHandle('gate')
def add_friend_respond_accept_1101(dynamic_id, data):
    """ respond to inviter """
    return friend.become_friends(dynamic_id, data)


@remoteserviceHandle('gate')
def add_friend_respond_refuse_1102(dynamic_id, data):
    """ refuse inviting """
    return friend.refuse_invitation(dynamic_id, data)


@remoteserviceHandle('gate')
def del_friend_request_1103(dynamic_id, data):
    """ delete friend from friend list """
    return friend.del_friend(dynamic_id, data)


@remoteserviceHandle('gate')
def add_black_list_1104(dynamic_id, data):
    """ add a player to blacklist by id """
    return friend.add_player_to_blacklist(dynamic_id, data)


@remoteserviceHandle('gate')
def del_black_list_1105(dynamic_id, data):
    """ delete a player from blacklist """
    return friend.del_player_from_blacklist(dynamic_id, data)


@remoteserviceHandle('gate')
def get_player_friend_list_1106(dynamic_id, data):
    return friend.get_player_friend_list(dynamic_id)


@remoteserviceHandle('gate')
def find_friend_request_1107(dynamic_id, data):
    return friend.find_friend_request(dynamic_id, data)


@remoteserviceHandle('gate')
def given_stamina_1108(dynamic_id, data):
    return friend.given_stamina(dynamic_id, data)


@remoteserviceHandle('gate')
def add_friend_request_1050(dynamic_id, is_online, target_id):
    return friend.add_friend_request_remote(dynamic_id, is_online, target_id)


@remoteserviceHandle('gate')
def become_friends_1051(dynamic_id, is_online, target_id):
    return friend.become_friends_remote(dynamic_id, is_online, target_id)


@remoteserviceHandle('gate')
def delete_friend_1052(dynamic_id, is_online, target_id):
    return friend.del_friend_remote(dynamic_id, is_online, target_id)
