
# -*- coding:utf-8 -*-
"""
created by sphinx on 14-10-11下午4:36.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file.common_pb2 import CommonResponse
from app.proto_file import brew_pb2


@remoteserviceHandle('gate')
def get_brew_info_1600(data, player):
    response = brew_pb2.BrewInfo()
    response.brew_times = player.brew.brew_times
    response.nectar = player.brew.nectar
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def do_brew_1601(data, player):
    request = brew_pb2.DoBrew()
    request.ParseFromString(data)
    response = CommonResponse()
    response.result = player.brew.do_brew(request.brew_type)
    return response.SerializePartialToString()
