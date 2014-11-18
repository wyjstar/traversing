#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle

@remoteserviceHandle
def get_before_fight_1701(data, player):
    """
    获取世界boss开战前的信息：
    1. 幸运武将
    2. 奇遇
    3. 伤害排名前十的玩家
    4. 最后击杀boss的玩家
    """

    pass

@remoteserviceHandle
def get_player_info_1702(data, player):
    """
    根据玩家排名，查看排行榜内的玩家信息。
    """
    pass


@remoteserviceHandle
def encourage_heros_1703(data, player):
    """
    使用金币或者元宝鼓舞士气。
    """
    pass

@remoteserviceHandle
def pvb_reborn_1704(data, player):
    """
    复活。
    """
    pass


@remoteserviceHandle
def pvb_fight_start_1705(data, player):
    """
    战斗开始。
    """
    pass
