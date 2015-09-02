#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
root to node.
"""
from gfirefly.server.globalobject import GlobalObject
from gfirefly.server.globalobject import rootserviceHandle


childsmanager = GlobalObject().root.childsmanager


class LimitHeroObj():
    act_id = 0

limit_hero_obj = LimitHeroObj()


def push_all_object_message(topic_id, msg):
    """
    向所有node节点（全服gate）推送消息。
    """
    for child in childsmanager.childs.values():
        child.push_all_object_remote(topic_id, msg)
    return True


@rootserviceHandle
def get_act_id_remote():
    """
    向随便一个gate节点 推送消息。
    """
    return limit_hero_obj.act_id
