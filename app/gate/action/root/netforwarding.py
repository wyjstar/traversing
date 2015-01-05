# coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from app.gate.core.users_manager import UsersManager
from gfirefly.server.globalobject import rootserviceHandle, remoteserviceHandle
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.virtual_character_manager import VCharacterManager
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.service.local.gateservice import local_service
from gfirefly.utils.services import CommandService
from shared.utils.ranking import Ranking
import cPickle

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
            return
        child_node = GlobalObject().child(oldvcharacter.node)
        result = child_node.callbackChild(key, dynamic_id, data)

        return result


@rootserviceHandle
def push_object_remote(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    groot.child('net').push_object_remote(topic_id, str(msg), send_list)


@rootserviceHandle
def get_guild_rank_remote():
    level_instance = Ranking.instance('GuildLevel')
    datas = level_instance.get(1, 9999)  # 获取排行最高的公会列表(999条)
    result = {}
    for data in datas:
        result[data[0]] = data[1]
    return result


@rootserviceHandle
def from_admin(msg):
    print 'from admin,=======================', msg


@rootserviceHandle
def from_admin_rpc(args):
    args = cPickle.loads(args)
    print args.get('args'), 'ssssss', args, 'sssssss'
    return cPickle.dumps({'result': False, 'data': {'aaa': 111, 'bbb': 222}})


@rootserviceHandle
def add_guild_to_rank_remote(g_id, dengji):
    level_instance = Ranking.instance('GuildLevel')
    level_instance.add(g_id, dengji)  # 添加rank数据


@rootserviceHandle
def login_chat_remote(dynamic_id, character_id, guild_id, nickname):
    return groot.child('chat').login_chat_remote(dynamic_id,
                                                 character_id,
                                                 nickname,
                                                 guild_id)


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

    oldvcharacter = VCharacterManager().get_by_id(character_id)
    # print VCharacterManager().character_client
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id, True) + args
        child_node = groot.child(oldvcharacter.node)
        return child_node.callbackChild(*args)
    else:
        transit_remote = GlobalObject().remote['transit']
        return transit_remote.push_message_remote(key, character_id, args)


remoteservice = CommandService('transitremote')
GlobalObject().remote['transit']._reference.addService(remoteservice)


@remoteserviceHandle('transit')
def pull_message_remote(key, character_id, *args):
    oldvcharacter = VCharacterManager().get_by_id(character_id)
    if oldvcharacter:
        args = args + (False,)
        args = (key, oldvcharacter.dynamic_id) + args
        child_node = groot.child(oldvcharacter.node)
        result = child_node.callbackChild(*args)
        # print 'gate found character to pull message:', oldvcharacter.__dict__, args, result
        return result
    else:
        return False


def save_playerinfo_in_db(dynamic_id):
    """
    """
    vcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
    child_node = groot.child(vcharacter.node)
    result = child_node.net_conn_lost_remote(dynamic_id)
    return result


def drop_client(dynamic_id, vcharacter):
    """清理客户端的记录
    """
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

        result = save_playerinfo_in_db(dynamic_id)
        print "net lost2++++++++++++++++", result
        if result:
            drop_client(dynamic_id, vcharacter)
            print "net lost3++++++++++++++++", dynamic_id, vcharacter
    else:
        UsersManager().drop_by_dynamic_id(dynamic_id)
