# -*- coding:utf-8 -*-
"""
created by server on 14-7-17下午4:36.
"""

from gfirefly.server.logobj import logger
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.battle.battle_unit import BattleUnit
from app.game.redis_mode import tb_character_info
from app.game.action.root.netforwarding import push_message
from app.game.component.mail.mail import MailComponent
from app.game.action.root import netforwarding
from app.game.component.achievement.user_achievement import CountEvent
from app.game.component.achievement.user_achievement import EventType
from app.game.core.lively import task_status
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file import friend_pb2
from app.proto_file.db_pb2 import Mail_PB
from app.proto_file.db_pb2 import Heads_DB
from app.proto_file.db_pb2 import Stamina_DB
import datetime
import time


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

    if not push_message('add_friend_request_remote', target_id,
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
    lord_data = tb_character_info.getObj(pid).get('lord_attr_info')
    if lord_data:
        battle_unit = BattleUnit.loads(lord_data.get('info'))
        response.hero_no = battle_unit.unit_no
        response.power = int(lord_data.get('power', 0))
        response.hp = battle_unit.hp
        response.atk = battle_unit.atk
        response.physical_def = battle_unit.physical_def
        response.magic_def = battle_unit.magic_def


@remoteserviceHandle('gate')
def get_player_friend_list_1106(data, player):
    response = friend_pb2.GetPlayerFriendsResponse()
    response.open_receive = player.stamina._open_receive
    print player.friends.friends

    for pid in player.friends.friends + [player.base_info.id]:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_friend_add = response.friends.add()
            response_friend_add.id = pid
            friend_data = player_data.hmget(['nickname', 'attackPoint',
                                             'heads', 'upgrade_time'])
            response_friend_add.nickname = friend_data['nickname']
            response_friend_add.gift = player.friends.last_present_times(pid)
            ap = 1
            if friend_data['attackPoint'] is not None:
                ap = int(friend_data['attackPoint'])
            response_friend_add.power = ap if ap else 0
            response_friend_add.last_time = friend_data['upgrade_time']

            friend_heads = Heads_DB()
            friend_heads.ParseFromString(friend_data['heads'])
            response_friend_add.hero_no = friend_heads.now_head

            # 添加好友主将的属性
            _with_battle_info(response_friend_add, pid)
        else:
            logger.error('friend_list, cant find player id:%d' % pid)
            player.friends.friends.remove(pid)

    for pid in player.friends.blacklist:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            black_data = player_data.hmget(['nickname', 'attackPoint',
                                            'heads', 'upgrade_time'])
            response_blacklist_add = response.blacklist.add()
            response_blacklist_add.id = pid
            response_blacklist_add.nickname = black_data['nickname']
            response_blacklist_add.gift = 0
            ap = int(friend_data['attackPoint'])
            response_blacklist_add.power = ap if ap else 0
            response_blacklist_add.last_time = friend_data['upgrade_time']

            black_heads = Heads_DB()
            black_heads.ParseFromString(black_data['heads'])
            response_blacklist_add.hero_no = black_heads.now_head

            # 添加好友主将的属性
            _with_battle_info(response_blacklist_add, pid)
        else:
            logger.error('black_list cant find player id:%d' % pid)
            player.friends.blacklist.remove(pid)

    for pid in player.friends.applicant_list:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_applicant_list_add = response.applicant_list.add()
            response_applicant_list_add.id = pid
            response_applicant_list_add.nickname = player_data.hget('nickname')
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
        player_data = tb_character_info.getObj(request.id_or_nickname)
        isexist = player_data.exists()
    else:
        nickname_obj = tb_character_info.getObj('nickname')
        isexist = nickname_obj.hexists(request.id_or_nickname)
        pid = nickname_obj.hget(request.id_or_nickname)
        player_data = tb_character_info.getObj(pid)

    if isexist:
        response.id = player_data.hget('id')
        response.nickname = player_data.hget('nickname')

        friend_data = player_data.hmget(['attackPoint', 'heads'])
        ap = 1
        if friend_data['attackPoint'] is not None:
            ap = int(friend_data['attackPoint'])
        response.power = ap if ap else 0

        friend_heads = Heads_DB()
        friend_heads.ParseFromString(friend_data['heads'])
        response.hero_no = friend_heads.now_head

        # 添加好友主将的属性
        _with_battle_info(response, player_data.hget('id'))

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

    player_data = tb_character_info.getObj(target_id)
    stamina_db = Stamina_DB()
    stamina_db.ParseFromString(player_data.hget('stamina'))
    open_receive = stamina_db.open_receive

    if not player.friends.given_stamina(target_id, if_present=open_receive):
        response.result = False
        response.result_no = 1  # fail
        return response.SerializePartialToString()  #

    player.friends.save_data()

    lively_event = CountEvent.create_event(EventType.PRESENT, 1, ifadd=True)
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])
    return response.SerializePartialToString()  # fail


@remoteserviceHandle('gate')
def add_friend_request_remote(target_id, is_online, player):
    # print 'target_id:', target_id, 'ison:', is_online
    logger.debug('add friend request:%s, %s', is_online, target_id)
    result = player.friends.add_applicant(target_id)
    # assert(result)
    player.friends.save_data()
    if is_online:
        remote_gate.push_object_remote(1110,
                                       player.base_info.id,
                                       [player.dynamic_id])
    return True


@remoteserviceHandle('gate')
def become_friends_remote(target_id, is_online, player):
    result = player.friends.add_friend(target_id, False)
    assert(result)
    player.friends.save_data()
    return True


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

    mail = Mail_PB()
    mail.sender_id = player.base_info.id
    mail.sender_name = player.base_info.base_name
    mail.sender_icon = player.base_info.head
    mail.receive_id = target_id
    mail.receive_name = ''
    mail.title = title
    mail.content = content
    mail.mail_type = MailComponent.TYPE_MESSAGE
    mail.prize = ''
    mail.send_time = int(time.time())

    # command:id 为收邮件的命令ID
    mail_data = mail.SerializePartialToString()
    netforwarding.push_message('receive_mail_remote', target_id, mail_data)

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


@remoteserviceHandle('gate')
def add_blacklist_request_remote(target_id, is_online, player):
    result = player.friends.add_blacklist(target_id)
    player.friends.save_data()
    return result
