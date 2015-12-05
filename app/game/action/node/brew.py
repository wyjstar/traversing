
# -*- coding:utf-8 -*-
"""
created by sphinx on 14-10-11下午4:36.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import brew_pb2

from gfirefly.server.globalobject import GlobalObject
remote_gate = GlobalObject().remote.get('gate')
from shared.db_opear.configs_data import game_configs
from app.game.core.task import hook_task, CONDITIONId


@remoteserviceHandle('gate')
def get_brew_info_1600(data, player):
    player.brew.check_time()
    response = brew_pb2.BrewInfo()
    response.brew_times = player.brew.brew_times
    response.brew_step = player.brew.brew_step
    response.nectar_num = player.brew.nectar
    response.nectar_cur = player.brew.nectar_cur
    response.gold = player.finance.gold
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def do_brew_1601(data, player):
    request = brew_pb2.DoBrew()
    request.ParseFromString(data)
    response = brew_pb2.BrewInfo()

    response.res.result = player.brew.do_brew(request.brew_type, response)
    if response.res.result:
        response.brew_times = player.brew.brew_times
        response.brew_step = player.brew.brew_step
        response.nectar_num = player.brew.nectar
        response.nectar_cur = player.brew.nectar_cur
        response.gold = player.finance.gold
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def taken_brew_1602(data, player):
    response = brew_pb2.BrewInfo()
    response.res.result = player.brew.taken_brew()
    if response.res.result:
        response.brew_times = player.brew.brew_times
        response.brew_step = player.brew.brew_step
        response.nectar_num = player.brew.nectar
        response.nectar_cur = player.brew.nectar_cur
        response.gold = player.finance.gold
    hook_task(player, CONDITIONId.BREW, 1)
    return response.SerializePartialToString()
