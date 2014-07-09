# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.game.logic.equipment import get_equipments_info
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
    get_type = request.type
    get_id = request.id

    equipments = get_equipments_info(dynamic_id, get_type, get_id)

    response = equipment_pb2.GetEquipmentResponse()
    res = response.res
    res.result = True

    print 'equipments:', equipments

    for obj in equipments:
        print obj.base_info.__dict__
        equipment_add = response.equipment.add()
        equipment_add.id = obj.base_info.id
        equipment_add.no = obj.base_info.equipment_no
        equipment_add.strengthen_lv = obj.attribute.strengthen_lv
        equipment_add.awakening_lv = obj.attribute.awakening_lv

        # TODO hero_no, set
    return response.SerializePartialToString()
