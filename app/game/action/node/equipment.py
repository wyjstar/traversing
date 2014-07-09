# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import equipment_pb2


@remote_service_handle
def get_equipments_401(dynamic_id, pro_data):
    """请求装备信息
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_pb2.GetEquipmentsRequest()
    request.ParseFromString(pro_data)

    print '#401 request:', request

    get_type = request.type
    get_id = request.id