# -*- coding:utf-8 -*-
"""
created by server on 14-7-21下午2:17.
"""

from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file.player_request_pb2 import CreatePlayerRequest
from app.game.logic.player import nickname_create


@remote_service_handle
def nickname_create_5(dynamic_id, request_proto):
    argument = CreatePlayerRequest()
    argument.ParseFromString(request_proto)
    nickname = argument.nickname
    return nickname_create(dynamic_id, nickname)

