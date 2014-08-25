# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.game.logic import item_group_helper
from app.game.logic.equipment import get_equipments_info, enhance_equipment, compose_equipment, melting_equipment
from app.game.service.gatenoteservice import remote_service_handle
from app.proto_file import equipment_request_pb2
from app.proto_file import equipment_response_pb2


@remote_service_handle
def get_equipments_401(dynamic_id, pro_data):
    """请求装备信息
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.GetEquipmentsRequest()
    request.ParseFromString(pro_data)
    get_type = request.type
    get_id = request.id

    equipments = get_equipments_info(dynamic_id, get_type, get_id)

    response = equipment_response_pb2.GetEquipmentResponse()
    res = response.res
    res.result = True

    for obj in equipments:
        # print obj.base_info.__dict__
        equipment_add = response.equipment.add()
        equipment_add.id = obj.base_info.id
        equipment_add.no = obj.base_info.equipment_no
        equipment_add.strengthen_lv = obj.attribute.strengthen_lv
        equipment_add.awakening_lv = obj.attribute.awakening_lv

    return response.SerializePartialToString()


@remote_service_handle
def enhance_equipment_402(dynamic_id, pro_data):
    """强化装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.EnhanceEquipmentRequest()
    request.ParseFromString(pro_data)
    equipment_id = request.id
    enhance_type = request.type
    enhance_num = request.num

    print request.id, request.type, request.num, "##request"

    enhance_info = enhance_equipment(dynamic_id, equipment_id, enhance_type, enhance_num)

    result = enhance_info.get('result')
    print request, "result"
    response = equipment_response_pb2.EnhanceEquipmentResponse()
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


@remote_service_handle
def compose_equipment_403(dynamic_id, pro_data):
    """合成装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.ComposeEquipmentRequest()
    request.ParseFromString(pro_data)
    equipment_chip_no = request.no
    print "request.no", request.no
    data = compose_equipment(dynamic_id, equipment_chip_no)
    result = data.get('result')
    print "compose_equipment.result", result
    response = equipment_response_pb2.ComposeEquipmentResponse()
    res = response.res
    if not result:
        res.result_no = data.get('result_no')
        res.message = data.get('message')
        return response.SerializePartialToString()

    equipment_obj = data.get('equipment_obj')
    equ = response.equ
    equ.id = equipment_obj.base_info.id
    equ.no = equipment_obj.base_info.equipment_no
    equ.strengthen_lv = equipment_obj.attribute.strengthen_lv
    equ.awakening_lv = equipment_obj.attribute.awakening_lv

    res.result = True
    return response.SerializePartialToString()


@remote_service_handle
def nobbing_equipment_404(dynamic_id, pro_data):
    """锤炼装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    pass
    # request = equipment_pb2.NobbingEquipmentRequest()
    # request.ParseFromString()
    #
    # equipment_id = request.id
    # nobbing_equipment(dynamic_id, equipment_id)


@remote_service_handle
def melting_equipment_405(dynamic_id, pro_data):
    """熔炼装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.MeltingEquipmentRequest()
    request.ParseFromString(pro_data)

    equipment_ids = request.id
    response = equipment_response_pb2.MeltingEquipmentResponse()

    for equipment_id in equipment_ids:
        data = melting_equipment(dynamic_id, equipment_id, response)
        result = data.get('result')

    response.res.result = True
    return response.SerializePartialToString()


@remote_service_handle
def awakening_equipment_406(dynamic_id, pro_data):
    """熔炼装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.AwakeningEquipmentRequest
    request.ParseFromString()

    equipment_id = request.id
    data = awakening_equipment(dynamic_id, equipment_id)

    result = data.get('result')
    response = equipment_response_pb2.MeltingEquipmentResponse()
    res = response.res
    if not result:
        res.result_no = data.get('result_no')
        res.message = data.get('message')
        return response.SerializePartialToString()

    player = data.get('player')
    gain = data.get('gain', [])
    item_group_helper.get_return(player, gain, response.cgr)

    return response.SerializePartialToString()




