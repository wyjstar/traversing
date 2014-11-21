#!/usr/bin/env python
# -*- coding: utf-8 -*-

from gfirefly.server.globalobject import remoteserviceHandle, GlobalObject
from app.proto_file import stage_request_pb2
from app.game.action.node.stage import assemble, fight_start
from gfirefly.server.logobj import logger
from app.proto_file.world_boss_pb2 import PvbFightResponse

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
    return remote_gate['world'].pvb_get_before_fight_info_remote()


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


@remoteserviceHandle('gate')
def pvb_fight_start_1705(pro_data, player):
    """开始战斗
    """
    request = stage_request_pb2.StageStartRequest()
    request.ParseFromString(pro_data)

    stage_id = request.stage_id  # 关卡编号
    unparalleled = request.unparalleled  # 无双编号

    logger.debug("unparalleled,%s" % unparalleled)

    line_up = {}  # {hero_id:pos}
    for line in request.lineup:
        if not line.hero_id:
            continue
        line_up[line.hero_id] = line.pos

    stage_info = fight_start(stage_id, line_up, unparalleled, 0, player)
    result = stage_info.get('result')

    response = PvbFightResponse()

    res = response.res
    res.result = result
    if stage_info.get('result_no'):
        res.result_no = stage_info.get('result_no')

    if not result:
        logger.info('进入关卡返回数据:%s', response)
        return response.SerializePartialToString(), stage_id

    red_units = stage_info.get('red_units')
    blue_units = stage_info.get('blue_units')

    for slot_no, red_unit in red_units.items():
        if not red_unit:
            continue
        red_add = response.red.add()
        assemble(red_add, red_unit)

    for blue_group in blue_units:
        blue_group_add = response.blue.add()
        for slot_no, blue_unit in blue_group.items():
            if not blue_unit:
                continue
            blue_add = blue_group_add.group.add()
            assemble(blue_add, blue_unit)

    response.red_best_skill = unparalleled
    # mock fight.
    result = remote_gate['world'].pvb_fight_remote(red_units,
            unparalleled, blue_units)
    response.fight_result = result['result']
    response.hp_left = result['hp_result']

    return response.SerializePartialToString()

