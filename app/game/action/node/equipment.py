#-*- coding:utf-8 -*-
"""
created by server on 14-6-26下午5:44.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.game.proto_file import game_game_pb2
from app.game.action.local.equipment import get_equip_list
from app.game.action.local.equipment import add_equip_list_data
from app.game.action.local.equipment import add_equip


@remote_service_handle
def get_equip_list_100(dynamicId, request_proto):
    """获取角色的装备栏信息
    """
    argument = game_game_pb2.EquipmentListeRequest()
    argument.ParseFromString(request_proto)

    result = get_equip_list(dynamicId)

    argument = game_game_pb2.EquipmentListResponse()
    argument.result = result.get('result')
    argument.equiplist = result.get('list')

    print argument

    return argument.SerializePartialToString()


def add_equip_101(dynamicId, request_proto):
    """获取角色的装备栏信息
    """
    argument = game_game_pb2.AddEquipmentRequest()
    argument.ParseFromString(request_proto)
    equipmentId = argument.equipmentId

    result = add_equip(dynamicId, equipmentId)

    argument = game_game_pb2.AddEquipmentResponse()
    argument.result = result.get('result')

    print argument

    return argument.SerializePartialToString()


def remove_equip_102(dynamicId, request_proto):
    """获取角色的装备栏信息
    """
    argument = game_game_pb2.EquipmentListeRequest()
    argument.ParseFromString(request_proto)

    result = get_equip_list(dynamicId)

    argument = game_game_pb2.EquipmentListResponse()
    argument.result = result.get('result')

    print argument

    return argument.SerializePartialToString()

@remote_service_handle
def add_equip_list_data_105(dynamicId, request_proto):
    """获取角色的装备栏信息
    """
    argument = game_game_pb2.EquipmentListeRequest()
    argument.ParseFromString(request_proto)
    equip_list_data = argument.message
    result = add_equip_list_data(dynamicId, equip_list_data)

    argument = game_game_pb2.EquipmentListResponse()
    argument.result = result.get('result')

    print argument

    return argument.SerializePartialToString()


