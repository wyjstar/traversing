
# -*- coding:utf-8 -*-
"""
created by sphinx on 14-10-11下午4:36.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import brew_pb2
from app.game.component.achievement.user_achievement import CountEvent,\
    EventType
from app.game.core.lively import task_status

from gfirefly.server.globalobject import GlobalObject
remote_gate = GlobalObject().remote['gate']
from shared.db_opear.configs_data import game_configs


@remoteserviceHandle('gate')
def get_brew_info_1600(data, player):
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
    open_stage_id = game_configs.base_config.get('cookingWineOpenStage')
    if player.stage_component.get_stage(open_stage_id).state == -2:
        response.res.result = False
        response.res.result_no = 837
        return response.SerializeToString()

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

    lively_event = CountEvent.create_event(EventType.WINE, 1, ifadd=True)
    tstatus = player.tasks.check_inter(lively_event)
    if tstatus:
        task_data = task_status(player)
        remote_gate.push_object_remote(1234, task_data, [player.dynamic_id])
    return response.SerializePartialToString()
