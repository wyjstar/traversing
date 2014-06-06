#coding:utf8
'''
Created on 2013-8-14

@author: lan (www.9miao.com)
'''
from gfirefly.server.globalobject import rootserviceHandle
from gfirefly.server.globalobject import GlobalObject
from gtwisted.utils import log
from shared.utils.const import const


@rootserviceHandle
def forwarding(key, dynamic_id, data):
    """
    """
    if key in const.ACCOUNT_COMMAND:
        print key, dynamic_id, data
        return GlobalObject().root.callChild('account', key, dynamic_id, data)

    

# @rootserviceHandle
# def pushObject(topicID,msg,sendList):
#     """
#     """
#     GlobalObject().root.callChildNotForResult("net","pushObject",topicID,msg,sendList)
#
# @rootserviceHandle
# def opera_player(pid,oprea_str):
#     """
#     """
#     vcharacter = VCharacterManager().getVCharacterByCharacterId(pid)#vcharacter是虚拟角色，VCharacterManager()虚拟角色管理器，{角色id:虚拟角色实例}
#     if not vcharacter:
#         node = "game1"
#     else:
#         node = vcharacter.getNode()
#     GlobalObject().root.callChildNotForResult(node,99,pid,oprea_str)
#
#
# def SavePlayerInfoInDB(dynamicId):
#     '''将玩家信息写入数据库'''
#     vcharacter = VCharacterManager().getVCharacterByClientId(dynamicId)
#     node = vcharacter.getNode()
#     result = GlobalObject().root.callChild(node,2,dynamicId)
#     return result
#
# def dropClient(deferResult,dynamicId,vcharacter):
#     '''清理客户端的记录
#     @param result: 写入后返回的结果
#     '''
#     node = vcharacter.getNode()
#     if node:#角色在场景中的处理
#         SceneSerManager().dropClient(node, dynamicId)
#
#     VCharacterManager().dropVCharacterByClientId(dynamicId)
#     UsersManager().dropUserByDynamicId(dynamicId)
#
# @rootserviceHandle
# def netconnlost(dynamicId):
#     '''客户端断开连接时的处理
#     @param dynamicId: int 客户端的动态ID
#     '''
#     vcharacter = VCharacterManager().getVCharacterByClientId(dynamicId)
#     if vcharacter and vcharacter.getNode()>0:#判断是否已经登入角色
#         vcharacter.lock()#锁定角色
#         result = SavePlayerInfoInDB(dynamicId)#保存角色,写入角色数据
#         if result:
#             dropClient(result,dynamicId,vcharacter)#清理客户端的数据
#     else:
#         UsersManager().dropUserByDynamicId(dynamicId)





