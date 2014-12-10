# -*- coding:utf-8 -*-
"""
created by server on 14-7-17上午11:07.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.game.core.item_group_helper import gain, get_return
from app.game.core.drop_bag import BigBag
from app.proto_file.runt_pb2 import RunSetRequest, RunSetResponse
from shared.db_opear.configs_data.game_configs import travel_event_config, \
    base_config, stage_config
import random
from gfirefly.server.logobj import logger
import time
from app.game.component.achievement.user_achievement import CountEvent,\
    EventType
from app.game.core.lively import task_status
from gfirefly.server.globalobject import GlobalObject


remote_gate = GlobalObject().remote['gate']


@remoteserviceHandle('gate')
def runt_set_841(data, player):
    """镶嵌符文"""
    args = RunSetRequest()
    args.ParseFromString(data)
    hero_no = args.hero_no
    runt_type = args.runt_type
    runt_po = args.runt_po
    runt_id = args.runt_id

    response = RunSetResponse()

    hero = player.hero_component.get_hero(hero_no)
    my_runt = {1: 1}  # {id:num}

    if not my_runt.get(runt_id):
        response.res.result = False
        response.res.result_no = 800
        return response.SerializeToString()

    if hero.runt.get(runt_type):
        if hero.runt.get(runt_type).get(runt_po):
            response.res.result = False
            response.res.result_no = 821
            return response.SerializeToString()
    else:
        hero.runt[runt_type] = {}

    hero.runt.get(runt_type)[runt_po] = runt_id
    hero.save_data()

    if my_runt.get(runt_id) > 1:
        my_runt[runt_id] -= 1
    else:
        del my_runt[runt_id]

    # TODO  save

    response.res.result = True
    return response.SerializeToString()
