# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午5:21.
"""
import datetime
from app.game.core.fight.battle_unit import BattleUnit

from app.game.logic.common.check import have_player
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_character_info
from app.game.redis_mode import tb_character_lord
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file import friend_pb2
from app.game.action.root.netforwarding import push_object
from app.game.action.root.netforwarding import push_message
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger


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
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    if len(request.target_ids) < 1:
        response.result = False
        response.result_no = 5  # fail
        return response.SerializePartialToString()  # fail

    target_id = request.target_ids[0]

    player = kwargs.get('player')
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

        push_object(1010, player.base_info.id, [invitee_player.dynamic_id])
        invitee_player.friends.save_data()
    else:
        if not push_message(1050, target_id, player.base_info.id):
            response.result = False
            response.result_no = 2
            return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()


@have_player
def add_friend_request_remote(dynamic_id, is_online, target_id, **kwargs):
    player = kwargs.get('player')
    result = player.friends.add_applicant(target_id)
    return result


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
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

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
def become_friends_remote(dynamic_id, is_online, target_id, **kwargs):
    player = kwargs.get('player')
    result = player.friends.add_friend(target_id, False)
    return result


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
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    for target_id in request.target_ids:
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
    request = friend_pb2.FriendCommon()
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
            if not push_message(1052, target_id, player.base_info.id):
                response.result = False
        response.result_no += 1

    return response.SerializePartialToString()


@have_player
def del_friend_remote(dynamic_id, is_online, target_id, **kwargs):
    player = kwargs.get('player')
    result = player.friends.del_friend(target_id, False)
    return result


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
    request = friend_pb2.FriendCommon()
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
    request = friend_pb2.FriendCommon()
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

    response = friend_pb2.GetPlayerFriendsResponse()
    player = kwargs.get('player')

    for pid in player.friends.friends:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_friend_add = response.friends.add()
            response_friend_add.id = pid
            response_friend_add.nickname = player_data.get('nickname')
            response_friend_add.gift = datetime.datetime.now().day

            # 添加好友主将的属性
            lord_data = tb_character_lord.getObjData(pid)
            if lord_data:
                info = lord_data.get('attr_info', {})
                battle_unit = BattleUnit.loads(info.get('info'))
                response_friend_add.hero_no = battle_unit.no
                response_friend_add.power = info.get('power', 0)
                response_friend_add.hp = battle_unit.hp
                response_friend_add.atk = battle_unit.atk
                response_friend_add.physical_def = battle_unit.physical_def
                response_friend_add.magic_def = battle_unit.magic_def
        else:
            logger.error('get_player_friend_list, cant find player id:%d' % pid)

    for pid in player.friends.blacklist:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_blacklist_add = response.blacklist.add()
            response_blacklist_add.id = pid
            response_blacklist_add.nickname = player_data.get('nickname')
            response_blacklist_add.gift = datetime.datetime.now().day

            # 添加好友主将的属性
            lord_data = tb_character_lord.getObjData(pid)
            if lord_data:
                info = lord_data.get('info', {})
                response_blacklist_add.hero_no = info.get('no', 0)
                response_blacklist_add.power = lord_data.get('power', 0)
                response_blacklist_add.hp = info.get('hp', 0)
                response_blacklist_add.atk = info.get('atk', 0)
                response_blacklist_add.physical_def = info.get('physical_def', 0)
                response_blacklist_add.magic_def = info.get('magic_def', 0)
        else:
            logger.error('get_player_friend_list, cant find player id:%d' % pid)

    for pid in player.friends.applicant_list:
        player_data = tb_character_info.getObjData(pid)
        if player_data:
            response_applicant_list_add = response.applicant_list.add()
            response_applicant_list_add.id = pid
            response_applicant_list_add.nickname = player_data.get('nickname')
            response_applicant_list_add.gift = datetime.datetime.now().day

            # 添加好友主将的属性
            lord_data = tb_character_lord.getObjData(pid)
            if lord_data:
                info = lord_data.get('info', {})
                response_applicant_list_add.hero_no = info.get('no', 0)
                response_applicant_list_add.power = lord_data.get('power', 0)
                response_applicant_list_add.hp = info.get('hp', 0)
                response_applicant_list_add.atk = info.get('atk', 0)
                response_applicant_list_add.physical_def = info.get('physical_def', 0)
                response_applicant_list_add.magic_def = info.get('magic_def', 0)
        else:
            logger.error('get_player_friend_list, cant find player id:' % pid)

    return response.SerializePartialToString()


@have_player
def find_friend_request(dynamic_id, data, **kwargs):
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
    response.nickname = 'none'
    response.atk = 111
    response.hero_no = 11
    response.gift = datetime.datetime.now().day

    if request.id_or_nickname.isdigit():
        player_data = tb_character_info.getObjData(request.id_or_nickname)
        if player_data:
            response.id = player_data.get('id')
            response.nickname = player_data.get('nickname')
    else:
        sql_result = util.GetOneRecordInfo('tb_character_info', dict(request.id_or_nickname))
        if sql_result:
            response.id = sql_result.get('id')
            response.nickname = sql_result.get('nickname')

    return response.SerializePartialToString()


@have_player
def given_stamina(dynamic_id, data, **kwargs):
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    player = kwargs.get('player')

    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)
    target_id = request.target_ids[0]

    if not player.given_stamina(target_id):
        response.result = False
        response.result_no = 1  # fail
        return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()  # fail
