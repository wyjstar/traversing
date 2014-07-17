#coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
from app.gate.core.users_manager import UsersManager
from app.proto_file import item_pb2
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject
from gtwisted.utils import log
from shared.utils.const import const
from app.gate.core.virtual_character_manager import VCharacterManager
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.service.local.gateservice import local_service


@rootserviceHandle
def forwarding(key, dynamic_id, data):
    """
    """

    print data

    if local_service._targets.has_key(key):
        return local_service.callTarget(key, dynamic_id, data)
    else:
        oldvcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
        print 'dynamic_id:', dynamic_id
        print VCharacterManager().__dict__
        print 'gaet forwarding oldvcharacter:', oldvcharacter
        if not oldvcharacter:
            return
        # if oldvcharacter.getLocked():  # 判断角色对象是否被锁定
        #     return
        node = VCharacterManager().get_node_by_dynamic_id(dynamic_id)

        result = GlobalObject().root.callChild(node, key, dynamic_id, data)

        return result
#

# @rootserviceHandle
# def pushObject(topic_id, msg, send_list):
#     """ send msg to client in send_list
#         send_list:
#     """
#     GlobalObject().root.callChildNotForResult("net", "pushObject", topic_id, msg, send_list)
#
#
# @rootserviceHandle
# def opera_player(pid, oprea_str):
#     """
#     """
#     vcharacter = VCharacterManager().get_character_by_characterid(pid)
#     if not vcharacter:
#         node = "game1"
#     else:
#         node = vcharacter.node
#     GlobalObject().root.callChildNotForResult(node, 99, pid, oprea_str)


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

    if vcharacter and vcharacter.node:
        vcharacter.locked = True  # 锁定角色

        result = save_playerinfo_in_db(dynamic_id)

        if result:
            drop_client(dynamic_id, vcharacter)
    else:
        UsersManager().drop_by_dynamic_id(dynamic_id)