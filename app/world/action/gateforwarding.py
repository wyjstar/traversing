#!/usr/bin/env python
# -*- coding: utf-8 -*-

"""
root to node.
"""
from gfirefly.server.globalobject import GlobalObject
childsmanager = GlobalObject().root.childsmanager

def push_message(topic_id, msg):
    """
    向所有node节点（全服gate）推送消息。
    """
    for child in childsmanager.childs:
        child.push_all_object_remote(topic_id, msg)
    return True
