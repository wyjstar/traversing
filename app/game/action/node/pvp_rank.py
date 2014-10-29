# -*- coding:utf-8 -*-
"""
created by sphinx on 27/10/14.
"""
from app.game.logic import pvp_rank
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def pvp_top_rank_request_1501(dynamic_id, data):
    return pvp_rank.pvp_top_rank_request(dynamic_id, data)


@remoteserviceHandle('gate')
def pvp_player_rank_request_1502(dynamic_id, data):
    return pvp_rank.pvp_player_rank_request(dynamic_id, data)


@remoteserviceHandle('gate')
def pvp_player_rank_refresh_request_1503(dynamic_id, data):
    return pvp_rank.pvp_player_rank_refresh_request(dynamic_id, data)


@remoteserviceHandle('gate')
def pvp_player_info_request_1504(dynamic_id, data):
    return pvp_rank.pvp_player_info_request(dynamic_id, data)


@remoteserviceHandle('gate')
def pvp_fight_request_1505(dynamic_id, data):
    return pvp_rank.pvp_fight_request(dynamic_id, data)
