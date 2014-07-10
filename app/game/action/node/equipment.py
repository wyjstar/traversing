# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.game.logic.equipment import get_equipments_info, enhance_equipment
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

@remote_service_handle
def enhance_equipment_402(dynamic_id, pro_data):
    """强化装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_pb2.EnhanceEquipmentRequest()
    request.ParseFromString(pro_data)
    equipment_id = request.id
    enhance_type = request.type
    enhance_num = request.num

    enhance_info = enhance_equipment(dynamic_id, equipment_id, enhance_type, enhance_num)

    result = enhance_info.get('result')

    response = equipment_pb2.EnhanceEquipmentResponse()
    res = response.res
    res.result = result
    if not result:
        res.result_no = enhance_info.get('result_no')
        res.message = enhance_info.get('message')
        return response.SerializePartialToString()

    enhance_record = enhance_info.get('enhance_record')

    for before_lv, after_lv, enhance_cost in enhance_record:
        data_format = response.data.add()
        data_format.before_lv = before_lv
        data_format.after_lv = after_lv
        data_format.cost_coin = enhance_cost

    return response.SerializePartialToString()
