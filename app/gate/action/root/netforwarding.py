#coding:utf8
"""
Created on 2013-8-14

@author: lan (www.9miao.com)
"""
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
    if local_service._targets.has_key(key):
        return local_service.callTarget(key, dynamic_id, data)
    else:
        oldvcharacter = VCharacterManager().get_by_dynamic_id(dynamic_id)
        if not oldvcharacter:
            return
        if oldvcharacter.getLocked():  # 判断角色对象是否被锁定
            return
        node = VCharacterManager().get_node_by_dynamic_id(dynamic_id)
        return GlobalObject().root.callChild(node, key, dynamic_id, data)
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
#
#
# def save_playerinfo_in_db(dynamicid):
#     """将玩家信息写入数据库"""
#     vcharacter = VCharacterManager().get_character_by_clientid(dynamicid)
#     node = vcharacter.getNode()
#     result = GlobalObject().root.callChild(node, 2, dynamicid)
#     return result
#
#
# def drop_client(dynamicid, vcharacter):
#     """清理客户端的记录
#     """
#     node = vcharacter.node
#     if node:  # 角色在场景中的处理
#         SceneSerManager().drop_client(node, dynamicid)
#
#     VCharacterManager().drop_character_by_clientid(dynamicid)
#
#
# @rootserviceHandle
# def netconnlost(dynamicid):
#     """客户端断开连接时的处理
#     @param dynamicid: int 客户端的动态ID
#     """
    # vcharacter = VCharacterManager().get_character_by_clientid(dynamicid)
    # if vcharacter and vcharacter.node > 0:  # 判断是否已经登入角色
    #     #vcharacter.lock()  # 锁定角色
    #     result = save_playerinfo_in_db(dynamicid)  # 保存角色,写入角色数据
    #     if result:
    #         drop_client(dynamicid, vcharacter)  # 清理客户端的数据






