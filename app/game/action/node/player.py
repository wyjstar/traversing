# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午2:17.
"""

from app.proto_file.player_request_pb2 import CreatePlayerRequest
from app.game.logic.player import nickname_create, buy_stamina, add_stamina
from gfirefly.server.globalobject import remoteserviceHandle


@remoteserviceHandle('gate')
def nickname_create_5(dynamic_id, request_proto):
    argument = CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname
    return nickname_create(dynamic_id, nickname)


@remoteserviceHandle('gate')
def buy_stamina_6(dynamic_id, request_proto):
    """购买体力"""
    return buy_stamina(dynamic_id)


@remoteserviceHandle('gate')
def add_stamina_7(dynamic_id, request_proto):
    """按时增长体力"""
    return add_stamina(dynamic_id)

