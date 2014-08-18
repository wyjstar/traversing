# -*- coding:utf-8 -*-
"""
created by server on 14-6-20下午1:40.
"""
from gfirefly.server.globalobject import GlobalObject
from app.gate.core.sceneser_manger import SceneSerManager
from app.gate.core.virtual_character_manager import VCharacterManager


def enter_scene(dynamicid):
    """进入场景
    @param dynamicid: int 客户端的ID
    """
    vplayer = VCharacterManager().get_character_by_clientid(dynamicid)
    if not vplayer:
        return None
    current_node = SceneSerManager().get_best_sceneid()
    vplayer.node = current_node
    response = GlobalObject().root.callChild(current_node, 601, dynamicid)
    SceneSerManager().add_client(current_node, vplayer.dynamicid)
    return response