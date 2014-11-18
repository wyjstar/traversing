# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

import datetime
from app.battle.battle_unit import BattleUnit
from app.game.redis_mode import tb_character_info
from app.game.redis_mode import tb_character_lord
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file import friend_pb2
from app.game.action.root.netforwarding import push_message
from gfirefly.dbentrust import util
from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.game.component.mail.mail import MailComponent
import time
from app.game.action.root import netforwarding


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def add_friend_request_1100(data, player):
    """ request to invite target as friend """
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

    if not push_message('add_friend_request_remote',
                        target_id,
                        player.base_info.id):
        response.result = False
        response.result_no = 2
        return response.SerializePartialToString()  # fail

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_friend_respond_accept_1101(data, player):
    """ respond to inviter """
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

        if not push_message('become_friends_remote',
                            target_id,
                            player.base_info.id):
            response.result = False

        # response.result_no += 1
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_friend_respond_refuse_1102(data, player):
    """ refuse inviting """
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


@remoteserviceHandle('gate')
def del_friend_request_1103(data, player):
    """ delete friend from friend list """
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

        response.result = push_message('delete_friend_remote',
                                       target_id,
                                       player.base_info.id)
        response.result_no += 1

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def add_black_list_1104(data, player):
    """ add a player to blacklist by id """
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


@remoteserviceHandle('gate')
def del_black_list_1105(data, player):
    """ delete a player from blacklist """
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


@remoteserviceHandle('gate')
def get_player_friend_list_1106(data, player):
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
            logger.error('friend_list, cant find player id:%d' % pid)
            player.friends.friends.remove(pid)

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
            logger.error('black_list cant find player id:%d' % pid)
            player.friends.blacklist.remove(pid)

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
            logger.error('applicant_list, cant find player id:%d' % pid)
            player.friends.applicant_list.remove(pid)

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def find_friend_request_1107(data, player):
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
        prere = dict(nickname=request.id_or_nickname)
        sql_result = util.GetOneRecordInfo('tb_character_info', prere)
        if sql_result:
            response.id = sql_result.get('id')
            response.nickname = sql_result.get('nickname')

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def given_stamina_1108(data, player):
    response = CommonResponse()
    response.result = True
    response.result_no = 0
    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)

    request = friend_pb2.FriendCommon()
    request.ParseFromString(data)
    target_id = request.target_ids[0]

    player_data = tb_character_info.getObjData(target_id)
    open_receive = player_data.get('stamina').get('open_receive')

    if not player.friends.given_stamina(target_id, if_present=open_receive):
        response.result = False
        response.result_no = 1  # fail
        return response.SerializePartialToString()  # fail

    player.friends.save_data()
    return response.SerializePartialToString()  # fail


@remoteserviceHandle('gate')
def add_friend_request_remote(target_id, is_online, player):
    # print 'target_id:', target_id, 'ison:', is_online
    logger.debug('add friend request:%s, %s', is_online, target_id)
    result = player.friends.add_applicant(target_id)
    player.friends.save_data()
    if is_online:
        remote_gate.push_object_remote(1110,
                                       player.base_info.id,
                                       [player.dynamic_id])
    return result


@remoteserviceHandle('gate')
def become_friends_remote(target_id, is_online, player):
    result = player.friends.add_friend(target_id, False)
    player.friends.save_data()
    return result


@remoteserviceHandle('gate')
def friend_private_chat_1060(data, player):
    """ 发送好友单聊邮件
    @author: jiang
    """
    response = CommonResponse()
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

    if not mail:
        response.result = False
        return response.SerializePartialToString()

    mail['send_time'] = int(time.time())
    receive_id = mail['receive_id']
    # command:id 为收邮件的命令ID
    netforwarding.push_message('receive_mail_remote', receive_id, mail)

    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def open_friend_receive_1061(data, player):
    """ 开启好友活力赠送
    @author: jiang
    """
    response = CommonResponse()
    player.stamina.open_receive()
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def close_friend_receive_1062(data, player):
    """ 关闭好友活力赠送
    @author: jiang
    """
    response = CommonResponse()
    player.stamina.close_receive()
    player.stamina.save_data()
    response.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def delete_friend_remote(target_id, is_online, player):
    result = player.friends.del_friend(target_id)
    player.friends.save_data()
    return result
