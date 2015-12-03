# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from app.gate.core.users_manager import UsersManager
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.service.local.gateservice import local_service
import cPickle
from gfirefly.server.logobj import logger
from gtwisted.core import reactor
from shared.utils.const import const

groot = GlobalObject().root


@rootserviceHandle
def forwarding_remote(key, dynamic_id, data):
    """
    """
    if key in local_service._targets:
        return local_service.callTarget(key, dynamic_id, data)
    else:
        oldvcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
        if not oldvcharacter:
            logger.error('cant find player:%s', dynamic_id)
            return
        if oldvcharacter.node:
            child_node = GlobalObject().child(oldvcharacter.node)
            result = child_node.callbackChild(key, dynamic_id, data)
            return result

        return False


@rootserviceHandle
def online_remote(character_id):
    """
    """
    oldvcharacter = VCharacterManager().get_by_id(character_id)
    if oldvcharacter is None:
        return 0
    return 1


@rootserviceHandle
def is_online_remote(key, dynamic_id, data):
    """
    """
    oldvcharacter = VCharacterManager().get_by_id(dynamic_id)
    if not oldvcharacter:
        return 'notonline'
    args = (key, oldvcharacter.dynamic_id, data)
    child_node = groot.child(oldvcharacter.node)
    return child_node.callbackChild(*args)


@rootserviceHandle
def push_object_remote(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list: dynamic_id
    """
    print(topic_id, msg, send_list, "push_object_remote=============")
    groot.child('net').push_object_remote(topic_id, str(msg), send_list)

@rootserviceHandle
def push_object_character_remote(topic_id, msg, send_character_list):
    """ send msg to client in send_list
        send_list: character_id
    """
    print(topic_id, msg, send_character_list, "push_object_character_remote=============")
    send_list = []
    for character_id in send_character_list:
        oldvcharacter = VCharacterManager().get_by_id(character_id)
        if oldvcharacter:
            send_list.append(oldvcharacter.dynamic_id)
    print(topic_id, msg, send_list, "push_object_character_remote=============")
    groot.child('net').push_object_remote(topic_id, str(msg), send_list)


@rootserviceHandle
def from_admin_rpc_remote(args):
    args = cPickle.loads(args)
    key = args.get('command')
    # gate_command = ['modify_user_info']
    # if args.get('command') in gate_command:
    #     com = "gm." + args['command'] + "(args)"
    #     res = eval(com)
    # else:
    print 'from_admin_rpc_remote', args
    if not args.get('uid'):
        return {'success': 0, 'message': 1}
    oldvcharacter = VCharacterManager().get_by_id(int(args.get('uid')))
    print 'oldvcharacter', oldvcharacter
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id, cPickle.dumps(args))
        print 'oldvcharacter.node', oldvcharacter.node
        child_node = groot.child(oldvcharacter.node)
        return child_node.callbackChild(*args)
    else:
        return {'success': 2}


@rootserviceHandle
def login_chat_remote(dynamic_id, character_id, guild_id, nickname, gag_time):
    return groot.child('chat').login_chat_remote(dynamic_id,
                                                 character_id,
                                                 nickname,
                                                 guild_id,
                                                 gag_time)


@rootserviceHandle
def login_guild_chat_remote(dynamic_id, guild_id):
    return groot.child('chat').login_guild_chat_remote(dynamic_id, guild_id)


@rootserviceHandle
def logout_guild_chat_remote(dynamic_id):
    return groot.child('chat').logout_guild_chat_remote(dynamic_id)


@rootserviceHandle
def del_guild_room_remote(guild_id):
    return groot.child('chat').del_guild_room_remote(guild_id)


@rootserviceHandle
def push_message_remote(key, character_id, args):
    # print 'gate receive push message'
    logger.debug("netforwarding.push_message_remote")
    logger.debug("push message %s %s %s" % (key, character_id, args))
    return to_transit(key, character_id, args)


def to_transit(key, character_id, args):
    oldvcharacter = VCharacterManager().get_by_id(character_id)
    # print VCharacterManager().character_client
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id) + args + (True,)
        child_node = groot.child(oldvcharacter.node)
        return child_node.callbackChild(*args)
    else:
        transit_remote = GlobalObject().remote['transit']
        return transit_remote.push_message_remote(key, character_id, *args)


@rootserviceHandle
def push_message_maintime_remote(key, character_id, maintain_time, args):
    logger.debug("netforwarding.push_message_maintime_remote")
    logger.debug("push time message %s %s %s %s" % (key, character_id,
                                                    maintain_time, args))

    oldvcharacter = VCharacterManager().get_by_id(character_id)
    # print VCharacterManager().character_client
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id) + args + (True,)
        child_node = groot.child(oldvcharacter.node)
        return child_node.callbackChild(*args)
    else:
        transit_remote = GlobalObject().remote['transit']
        return transit_remote.push_message_maintime_remote(key,
                                                           character_id,
                                                           maintain_time,
                                                           *args)


@rootserviceHandle
def pull_message_remote(character_id):
    transit_remote = GlobalObject().remote['transit']
    return transit_remote.pull_message_remote(character_id)


def save_playerinfo_in_db(dynamic_id, vcharacter):
    child_node = groot.child(vcharacter.node)
    result = child_node.net_conn_lost_remote(dynamic_id)
    return result


def drop_client(dynamic_id, vcharacter):
    """清理客户端的记录"""
    node = vcharacter.node
    if node:  # 角色在场景中的处理
        SceneSerManager().drop_client(node, dynamic_id)

    VCharacterManager().drop_by_dynamic_id(dynamic_id)


@rootserviceHandle
def net_conn_lost_remote_noresult(dynamic_id):
    """客户端断开连接时的处理
    @param dynamic_id: int 客户端的动态ID
    """
    vcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
    print "net lost1++++++++++++++++", dynamic_id
    if vcharacter and vcharacter.node:
        vcharacter.locked = True  # 锁定角色
        vcharacter.state = 0  # 设置掉线状态
        reactor.callLater(const.KEEP_USER_AFTER_DROP,
                          net_conn_lost,
                          dynamic_id)
    else:
        UsersManager().drop_by_dynamic_id(dynamic_id)


def net_conn_lost(dynamic_id):
    """docstring for net_conn_lost"""
    vcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
    if not vcharacter or vcharacter.state == 1:
        return
    result = save_playerinfo_in_db(dynamic_id, vcharacter)

    if result:
        drop_client(dynamic_id, vcharacter)
        UsersManager().drop_by_dynamic_id(dynamic_id)
        print "net lost3++++++++++++++++", dynamic_id, vcharacter


@rootserviceHandle
def get_act_id_from_world_remote():
    world_remote = GlobalObject().remote['world']
    return world_remote.get_act_id_remote()
