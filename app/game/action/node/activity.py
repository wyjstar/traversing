# -*- coding:utf-8 -*-
"""
"""

from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import activity_pb2
from shared.db_opear.configs_data import game_configs
from app.game.core.item_group_helper import gain, get_return
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_act_gift_1832(data, player):
    args = activity_pb2.GetActGiftRequest()
    args.ParseFromString(data)
    act_id = args.act_id
    response = activity_pb2.GetActGiftResponse()
    response.res.result = False

    act_conf = game_configs.activity_config.get(act_id)
    is_open = player.base_info.is_activiy_open(act_id)
    if not act_conf or not is_open:
        response.res.result_no = 800
        return response.SerializeToString()
    act_type = act_conf.type
    received_ids = player.act.received_ids.get(act_type)
    if received_ids and act_id in received_ids:
        response.res.result_no = 800
        return response.SerializeToString()
    if act_type == 20:  # 战力
        res = get_20_gift(act_conf, response)
    elif act_type == 21:  # 通关关卡
        res = get_21_gift(act_conf, response)
    if res:
        player.act.received_ids.append(act_id)
        player.act.save_data()

    return response.SerializeToString()


def get_20_gift(player, act_conf, response):  # 战力
    # power = player.line_up_component.combat_power
    # if act_conf.parameterA > player.line_up_component.highest_power:
    if act_conf.parameterA > player.line_up_component.combat_power:
        response.res.result_no = 800
        return 0
    gain_data = act_conf.reward
    return_data = gain(player, gain_data, const.ACT20)
    get_return(player, return_data, response.gain)
    return 1


def get_21_gift(player, act_conf, response):  # 通关关卡
    if player.stage_component.get_stage(act_conf.parameterA).state != 1:
        response.res.result_no = 800
        return 0
    gain_data = act_conf.reward
    return_data = gain(player, gain_data, const.ACT21)
    get_return(player, return_data, response.gain)
    return 1


@remoteserviceHandle('gate')
def get_act_info_1831(data, player):
    """get act info"""
    args = activity_pb2.GetActInfoRequese()
    args.ParseFromString(data)
    act_type = args.act_type

    response = activity_pb2.GetActInfoResponse()
    received_ids = player.ap_gift.received_ids.get(act_type)
    if received_ids:
        for id in received_ids:
            response.received_ids.append(id)
    response.res.result = True
    return response.SerializeToString()
