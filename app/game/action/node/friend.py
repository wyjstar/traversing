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
from shared.db_opear.configs_data import game_configs, data_helper
from app.proto_file import friend_pb2
from app.proto_file.db_pb2 import Mail_PB
from app.proto_file.db_pb2 import Heads_DB
from app.proto_file.db_pb2 import Stamina_DB
import datetime
import random
import time
from app.game.core.item_group_helper import gain, get_return
from shared.db_opear.configs_data.game_configs import base_config
from app.game.component.mine.monster_mine import MineOpt
from shared.utils.const import const


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
    print 'del_friend_request_1103', request.target_ids
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


def _with_battle_info(response, friend):
    # 添加好友主将的属性
    column = ['id', 'lord_attr_info', 'heads', 'nickname', 'vip_level',
              'attackPoint', 'upgrade_time', 'level']
    friend_data = friend.hmget(column)
    if friend_data.get('lord_attr_info').get('info'):
        battle_unit = BattleUnit.loads(friend_data.get('lord_attr_info').get('info'))
        response.hero_no = battle_unit.unit_no
        # response.power = int(friend_data.get('power', 0))
        response.hp = battle_unit.hp
        response.atk = battle_unit.atk
        response.physical_def = battle_unit.physical_def
        response.magic_def = battle_unit.magic_def
#         response.buddy_head = 1#battle_unit.unit_no

        response.buddy_head = battle_unit.unit_no
        response.buddy_power = int(battle_unit.power)
        response.buddy_level = battle_unit.level

    response.id = friend_data['id']

    friend_heads = Heads_DB()
    friend_heads.ParseFromString(friend_data['heads'])
    response.hero_no = friend_heads.now_head
    response.last_time = friend_data['upgrade_time']
    response.vip_level = friend_data['vip_level']
    response.level = friend_data['level']

    response.nickname = friend_data['nickname']
    if friend_data['attackPoint'] is not None:
        response.power = int(friend_data['attackPoint'])


@remoteserviceHandle('gate')
def get_player_friend_list_1106(data, player):
    response = friend_pb2.GetPlayerFriendsResponse()
    response.open_receive = player.stamina._open_receive
    print player.friends.friends

    _update = False

    for pid in player.friends.friends + [player.base_info.id]:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_friend_add = response.friends.add()
            friend_data = player_data.hmget(['lively', 'last_day'])
            response_friend_add.gift = player.friends.last_present_times(pid)

            print 'friend_data', friend_data['lively'], pid
            lively = int(friend_data.get('lively', 0))
            today = time.strftime("%Y%m%d", time.localtime(time.time()))
            if today != friend_data.get('last_day', '0'):
                lively = 0
            response_friend_add.current = lively
            print '11111111111111111', base_config['friendActivityValue']
            response_friend_add.target = base_config['friendActivityValue']
            stat, update = player.friends.get_reward(pid, today)
            if update:
                _update = True
            response_friend_add.stat = stat

            # 添加好友主将的属性
            _with_battle_info(response_friend_add, player_data)
            response_friend_add.gift = player.friends.last_present_times(pid)
        else:
            logger.error('friend_list, cant find player id:%d' % pid)
            player.friends.friends.remove(pid)
    if _update:
        player.friends.save_data()

    for pid in player.friends.blacklist:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_blacklist_add = response.blacklist.add()

            # 添加好友主将的属性
            _with_battle_info(response_blacklist_add, player)
        else:
            logger.error('black_list cant find player id:%d' % pid)
            player.friends.blacklist.remove(pid)

    print 'player.friends.applicant_list', player.friends.applicant_list
    for pid in player.friends.applicant_list:
        print 'player.friends.applicant_list', pid
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_applicant_list_add = response.applicant_list.add()

            # 添加好友主将的属性
            _with_battle_info(response_applicant_list_add, player_data)
        else:
            logger.error('applicant_list, cant find player id:%d' % pid)
            player.friends.applicant_list.remove(pid)

    logger.debug("1106 return friends list %s", response)
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def draw_friend_lively_1199(data, player):
    request = friend_pb2.DrawRewardReq()
    request.ParseFromString(data)
    response = friend_pb2.DrawRewardRsp()
    response.fid = request.fid
    today = time.strftime("%Y%m%d", time.localtime(time.time()))
    stat, update = player.friends.get_reward(request.fid, today)
    if stat:
        response.res.result = False
        response.res.result_no = 11991  # 已领取
    else:
        player_data = tb_character_info.getObj(request.fid)
        friend_data = player_data.hmget(['lively', 'last_day'])
        lively = int(friend_data.get('lively', 0))
        if today != friend_data.get('last_day', ''):
            lively = 0
        if lively < base_config['friendActivityValue']:
            response.res.result = False
            response.res.result_no = 11992  # 未完成
        else:
            response.res.result = True
            reward = base_config['friendActivityReward']
            lively_reward = data_helper.parse(reward)
            return_data = gain(player, lively_reward, const.LIVELY_REWARD)  # 获取
            get_return(player, return_data, response.gain)
            player.friends.set_reward(request.fid, today, 1)
            update = True

    if update:
        player.friends.save_data()

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
    print 'request.id_or_nickname', request.id_or_nickname
    if request.id_or_nickname.isdigit():
        player_data = tb_character_info.getObj(request.id_or_nickname)
        isexist = player_data.exists()
    else:
        nickname_obj = tb_character_info.getObj('nickname')
        isexist = nickname_obj.hexists(request.id_or_nickname)
        pid = nickname_obj.hget(request.id_or_nickname)
        player_data = tb_character_info.getObj(pid)
    print 'isexist', isexist
    if isexist:
        response.id = player_data.hget('id')
        response.nickname = player_data.hget('nickname')

        friend_data = player_data.hmget(['attackPoint',
                                         'heads',
                                         'level',
                                         'upgrade_time'])
        ap = 1
        if friend_data['attackPoint'] is not None:
            ap = int(friend_data['attackPoint'])
        response.power = ap if ap else 0

        friend_heads = Heads_DB()
        friend_heads.ParseFromString(friend_data['heads'])
        response.hero_no = friend_heads.now_head
        response.level = friend_data['level']
        response.b_rank = 1
        response.last_time = friend_data['upgrade_time']

        # 添加好友主将的属性
        # _with_battle_info(response, player_data)

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def recommend_friend_1198(data, player):
    response = friend_pb2.RecommendRes()
    x = base_config['friendApplyLevelGap']
    front = player.base_info.level - x
    back = player.base_info.level + x
    uids = MineOpt.rand_level("user_level", front, back+1)
    print uids
    statics = base_config['FriendRecommendNum']
    count = 0
    now = int(time.time())

    has_one = []
    for uid in uids:
        if uid in has_one:
            continue
        else:
            has_one.append(uid)
        if uid == player.base_info.id:
            continue
        if player.friends.is_friend(uid):
            continue

        player_data = tb_character_info.getObj(uid)
        isexist = player_data.exists()
        if count >= statics:
            break

        if isexist:
            last_time = player_data.hget('upgrade_time')
            if now - last_time > base_config['friendApplyOfflineDay']*24*60*60:
                continue
            count += 1
            friend = response.rfriend.add()
            friend.id = player_data.hget('id')
            print 'friend.id', friend.id
            friend.nickname = player_data.hget('nickname')
            print 'friend.nickname', friend.nickname
            friend_data = player_data.hmget(['attackPoint', 'heads',
                                             'level', 'upgrade_time'])
            ap = 1
            if friend_data['attackPoint'] is not None:
                ap = int(friend_data['attackPoint'])
            friend.power = ap if ap else 0

            friend_heads = Heads_DB()
            friend_heads.ParseFromString(friend_data['heads'])
            friend.hero_no = friend_heads.now_head

            friend.level = friend_data['level']
            friend.b_rank = 1
            friend.last_time = friend_data['upgrade_time']

            # 添加好友主将的属性
            _with_battle_info(friend, player_data)

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


@remoteserviceHandle('gate')
def get_recommend_friend_list_1109(data, player):
    response = friend_pb2.GetRecommendFriendsResponse()
    response.open_receive = player.stamina._open_receive

    allplayer_ids = tb_character_info.smem('all')
    allplayer_ids.remove(player.base_info.id)

    recommend_num = game_configs.base_config.get('FriendRecommendNum')
    recommend_ids = []
    while (len(recommend_ids) < recommend_num and allplayer_ids):
        recommend_id = random.choice(allplayer_ids)
        allplayer_ids.remove(recommend_id)
        recommend_ids.append(recommend_id)

    for pid in recommend_ids:
        player_data = tb_character_info.getObj(pid)
        if player_data.exists():
            response_friend_add = response.recommend.add()
            _with_battle_info(response_friend_add, player_data)
            response_friend_add.gift = player.friends.last_present_times(pid)
        else:
            logger.error('friend_list, cant find player id:%d' % pid)
            player.friends.friends.remove(pid)

    return response.SerializePartialToString()
