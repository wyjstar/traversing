#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import rootserviceHandle
from app.proto_file import world_boss_pb2


@rootserviceHandle
def pvb_get_before_fight_info():
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    """
    print "*-$"*80
    response = world_boss_pb2.PvbGetBeforeFightResponse()
    response.high_hero = 10003
    response.skill_no = 10002
    return response.SerializeToString()


@rootserviceHandle
def on_test_remote(a, b):
    print 'on_test_remote', a, b
    return True







