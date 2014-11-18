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
def forwarding(key, dynamic_id, data):
    """
    """
    if key in local_service._targets:
        return local_service.callTarget(key, dynamic_id, data)
    else:
        oldvcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
        if not oldvcharacter:
            return
        result = groot.callChild(oldvcharacter.node, key, dynamic_id, data)

        return result


@rootserviceHandle
def forwarding_test(key, dynamic_id, data):
    """
    """
    if key in local_service._targets:
        return local_service.callTarget(key, dynamic_id, data)
    else:
        result = groot.callChildByName('game', key, dynamic_id, data)
        return result


@rootserviceHandle
def push_object(topic_id, msg, send_list):
    """ send msg to client in send_list
        send_list:
    """
    groot.childsmanager.callChildByNameNotForResult("net",
                                                    "pushObject",
                                                    topic_id,
                                                    msg,
                                                    send_list)


@rootserviceHandle
def push_chat_message(send_list, msg):
    groot.childsmanager.callChildByNameNotForResult("net",
                                                    "pushObject",
                                                    1000,
                                                    msg,
                                                    send_list)


@rootserviceHandle
def get_guild_rank():
    level_instance = Ranking.instance('GuildLevel')
    data = level_instance.get("GuildLevel", 9999)  # 获取排行最高的公会列表(999条)
    return data


@rootserviceHandle
def from_admin(msg):
    print 'from admin,=======================', msg


@rootserviceHandle
def from_admin_rpc(args):
    args = cPickle.loads(args)
    print args.get('args'), 'ssssss', args, 'sssssss'
    return cPickle.dumps({'result': False, 'data': {'aaa': 111, 'bbb': 222}})


@rootserviceHandle
def add_guild_to_rank(g_id, dengji):
    level_instance = Ranking.instance('GuildLevel')
    level_instance.add(g_id, level=dengji)  # 添加rank数据


@rootserviceHandle
def login_chat(dynamic_id, character_id, guild_id, nickname):
    groot.callChildByName('chat', 1001, dynamic_id, character_id,
                          nickname, guild_id)


@rootserviceHandle
def login_guild_chat(dynamic_id, guild_id):
    groot.callChildByName('chat', 1004, dynamic_id, guild_id)


@rootserviceHandle
def logout_guild_chat(dynamic_id):
    groot.callChildByName('chat', 1005, dynamic_id)


@rootserviceHandle
def del_guild_room(guild_id):
    groot.callChildByName('chat', 1006, guild_id)


@rootserviceHandle
def push_message(key, character_id, args, kw):
    # print 'gate receive push message'

    oldvcharacter = VCharacterManager().get_by_id(character_id)
    # print VCharacterManager().character_client
    if oldvcharacter:
        args = (key, oldvcharacter.dynamic_id, True) + args
        return groot.callChild(oldvcharacter.node, *args, **kw)
    else:
        return GlobalObject().remote['transit'].callRemote("push_message",
                                                           key,
                                                           character_id,
                                                           args, kw)


remoteservice = CommandService('transitremote')
GlobalObject().remote['transit']._reference.addService(remoteservice)


@remoteserviceHandle('transit')
def pull_message(key, character_id, *args, **kw):
    oldvcharacter = VCharacterManager().get_by_id(character_id)
    if oldvcharacter:
        print 'gate found character to pull message:', oldvcharacter.__dict__
        kw['is_online'] = False
        args = (key, oldvcharacter.dynamic_id) + args
        return GlobalObject().root.callChild(oldvcharacter.node,
                                             *args,
                                             **kw)
    else:
        return False


def save_playerinfo_in_db(dynamic_id):
    """
    """
    vcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
    node = vcharacter.node
    result = GlobalObject().root.callChild(node, 602, dynamic_id)
    return result


def drop_client(dynamic_id, vcharacter):
    """清理客户端的记录
    """
    node = vcharacter.node
    if node:  # 角色在场景中的处理
        SceneSerManager().drop_client(node, dynamic_id)

    VCharacterManager().drop_by_dynamic_id(dynamic_id)


@rootserviceHandle
def net_conn_lost(dynamic_id):
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
