#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle, GlobalObject
#from app.proto_file import world_boss_pb2

remote_gate = GlobalObject().remote['gate']

@remoteserviceHandle('gate')
def get_before_fight_1701(data, player):
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    """
    print "game:get_before_fight_1701"
    return remote_gate.call_remote_for_result("world_forwarding", "pvb_get_before_fight_info")
    #response = world_boss_pb2.PvbGetBeforeFightResponse()
    #response.high_hero = 10001
    #response.skill_no = 10002
    #return response.SerializeToString()



@remoteserviceHandle('gate')
def get_player_info_1702(data, player):
    """
    根据玩家排名，查看排行榜内的玩家信息。
    """
    pass


@remoteserviceHandle('gate')
def encourage_heros_1703(data, player):
    """
    使用金币或者元宝鼓舞士气。
    """
    # 1. 校验金币或者元宝
    # 2. 校验CD
    # 3. 减少金币
    # 4. 更新战斗力
    pass

@remoteserviceHandle('gate')
def pvb_reborn_1704(data, player):
    """
    使用元宝复活。
    """
    # 1. 校验元宝
    pass


@remoteserviceHandle
def pvb_fight_start_1705(data, player):
    """
    战斗开始。
    """
    # 1. 校验CD
    # 2. 准备战斗数据
    # 3. 模拟战斗
    # 4. 返回客户端, 战斗输入和战斗结果


    pass

@remoteserviceHandle
def pvb_after_fight():
    """
    1. 清空临时数据，鼓舞等
    2. 发放奖励
    """
    pass
