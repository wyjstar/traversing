# -*- coding:utf-8 -*-
"""
created by server on 14-7-9上午11:28.
"""
from app.game.core import item_group_helper
from app.proto_file import equipment_request_pb2
from app.proto_file import equipment_response_pb2
from gfirefly.server.globalobject import remoteserviceHandle
from gfirefly.server.logobj import logger
from shared.utils.const import const


@remoteserviceHandle('gate')
def get_equipments_401(pro_data, player):
    """请求装备信息
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.GetEquipmentsRequest()
    request.ParseFromString(pro_data)
    get_type = request.type
    get_id = request.id

    equipments = get_equipments_info(get_type, get_id, player)

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

        for before_lv, after_lv, enhance_cost in obj.enhance_record.enhance_record:
            data_format = equipment_add.data.add()
            data_format.before_lv = before_lv
            data_format.after_lv = after_lv
            data_format.cost_coin = enhance_cost

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def enhance_equipment_402(pro_data, player):
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

    enhance_info = enhance_equipment(equipment_id,
                                     enhance_type,
                                     enhance_num,
                                     player)

    result = enhance_info.get('result')
    response = equipment_response_pb2.EnhanceEquipmentResponse()
    res = response.res
    res.result = result
    if not result:
        res.result_no = enhance_info.get('result_no')
        res.message = enhance_info.get('message')
        return response.SerializePartialToString()

    enhance_record = enhance_info.get('enhance_record')

    data_format = response.data.add()
    flag = 1
    data_format.cost_coin = 0
    for before_lv, after_lv, enhance_cost in enhance_record:
        if flag == 1:
            data_format.before_lv = before_lv
            flag = 2
        data_format.after_lv = after_lv
        data_format.cost_coin += enhance_cost

    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def compose_equipment_403(pro_data, player):
    """合成装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.ComposeEquipmentRequest()
    request.ParseFromString(pro_data)
    equipment_chip_no = request.no
    data = compose_equipment(equipment_chip_no, player)
    result = data.get('result')
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


@remoteserviceHandle('gate')
def nobbing_equipment_404(pro_data, player):
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


@remoteserviceHandle('gate')
def melting_equipment_405(pro_data, player):
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
        melting_equipment(equipment_id, response, player)

    response.res.result = True
    return response.SerializePartialToString()


@remoteserviceHandle('gate')
def awakening_equipment_406(pro_data, player):
    """熔炼装备
    @param dynamic_id:
    @param pro_data:
    @return:
    """
    request = equipment_request_pb2.AwakeningEquipmentRequest
    request.ParseFromString()

    equipment_id = request.id
    data = awakening_equipment(equipment_id, player)

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


def get_equipments_info(get_type, get_id, player):
    """
    @param get_type: 装备类型 -1：一件 0：全部 1：武器 2：头盔 3：衣服 4：项链 5：饰品 6：宝物
    @param get_id: 装备ID
    @return: 装备的详细信息 []
    """
    equipments = []
    if get_type == -1:
        obj = player.equipment_component.get_equipment(get_id)
        if obj:
            equipments.append(obj)
    elif get_type == 0:
        equipments.extend(player.equipment_component.get_all())
    else:
        equipments.extend(player.equipment_component.get_by_type(get_type))

    return equipments


def enhance_equipment(equipment_id, enhance_type, enhance_num, player):
    """装备强化
    @param dynamic_id:  客户端动态ID
    @param equipment_id: 装备ID
    @param enhance_type: 强化类型
    @param enhance_num: 强化次数
    @param kwargs:
    @return:
    """

    equipment_obj = player.equipment_component.get_equipment(equipment_id)
    # print equipment_obj, "equipment_obj"

    if enhance_type == 2 and not player.vip_component.equipment_strength_one_key:
        logger.debug('enhance_equipment_vip_error!%d' % player.vip_component.equipment_strength_one_key)
        return {'result': False, 'result_no': 403, 'message': u''}

    if not equipment_obj:
        logger.debug('enhance_equipment_no_equipment!')
        return {'result': False, 'result_no': 401, 'message': u''}

    enhance_record = []

    curr_coin = player.finance.coin  # 用户金币
    # curr_coin = 1000000
    enhance_cost = equipment_obj.attribute.enhance_cost  # 强化消耗
    if not enhance_cost or curr_coin < enhance_cost:
        return {'result': False, 'result_no': 101, 'message': u''}

    if equipment_obj.attribute.strengthen_lv > 200 or \
        equipment_obj.attribute.strengthen_lv + enhance_num > player.level.level + equipment_obj.strength_max:
        return {'result': False, 'result_no': 402, 'message': u''}

    for i in xrange(0, enhance_num):
        result = __do_enhance(player, equipment_obj)
        if not result.get('result'):
            return result
        enhance_record.append(result.get('record'))

    print equipment_obj.enhance_record
    equipment_obj.enhance_record.enhance_record.extend(enhance_record)

    # 保存
    equipment_obj.save_data()
    player.finance.save_data()

    return {'result': True, 'enhance_record': enhance_record}


def __do_enhance(player, equipment_obj):
    """
    @param player:  用户对象
    @param equipment_obj: 装备对象
    @return: {'before_lv':1, 'after_lv':2, 'cost_coin':21}
    """
    enhance_cost = equipment_obj.attribute.enhance_cost  # 强化消耗
    player.finance.consume(const.COIN, enhance_cost)
    player.finance.save_data()

    before_lv, after_lv = equipment_obj.enhance(player)

    return {'result': True, 'record': (before_lv, after_lv, enhance_cost)}


def compose_equipment(chip_no, player):
    """合成装备
    """
    chip = player.equipment_chip_component.get_chip(chip_no)
    # 没有碎片
    if not chip:
        return {'result': False, 'result_no': 102, 'message': u''}

    compose_num = chip.compose_num
    chip_num = chip.chip_num
    # print "chip_num", compose_num, chip_num
    # 碎片不足
    if chip_num < compose_num:
        return {'result': False, 'result_no': 102, 'message': u''}
    equipment_obj = player.equipment_component.add_equipment(chip.combine_result)
    chip.chip_num -= compose_num
    player.equipment_chip_component.save_data()
    return {'result': True, 'equipment_obj': equipment_obj}


def melting_equipment(equipment_ids, response, player):
    """熔炼
    @param dynamic_id:
    @param equipment_ids:
    @param kwargs:
    @return:
    """
    equipment_obj = player.equipment_component.get_equipment(equipment_ids)
    if not equipment_obj:
        return {'result': False, 'result_no': 401, 'message': u''}
    melting_items = equipment_obj.melting_item
    gain = item_group_helper.gain(player, melting_items)

    item_group_helper.get_return(player, gain, response.cgr)

    # 添加强化金币
    strength_coin = 0
    for record in equipment_obj.enhance_record.enhance_record:
        strength_coin += record[2]

    response.cgr.finance.coin += strength_coin


def awakening_equipment(equipment_id, player):
    """觉醒
    @param dynamic_id:
    @param equipment_id:
    @param kwargs:
    @return:
    """
    pass
