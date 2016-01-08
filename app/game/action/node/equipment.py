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
from shared.db_opear.configs_data import game_configs
from app.game.core.notice import push_notice
from shared.tlog import tlog_action
from app.game.core.activity import target_update
from shared.common_logic.feature_open import is_not_open, FO_EQUIP_ENHANCE, FO_EQUIP_COMPOSE, FO_EQUIP_SACRIFICE


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
        obj.update_pb(equipment_add)

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

    response = equipment_response_pb2.EnhanceEquipmentResponse()

    enhance_info = enhance_equipment(equipment_id,
                                     enhance_type,
                                     player)

    result = enhance_info.get('result')
    res = response.res
    res.result = result
    if not result:
        res.result_no = enhance_info.get('result_no')
        res.message = enhance_info.get('message')
        return response.SerializePartialToString()

    enhance_record = enhance_info.get('enhance_record')

    # flag = 1
    # data_format.cost_coin = 0
    for before_lv, after_lv, enhance_cost in enhance_record:
        data_format = response.data.add()
        # if flag == 1:
        #     data_format.before_lv = before_lv
        #     flag = 2
        data_format.before_lv = before_lv
        data_format.after_lv = after_lv
        data_format.cost_coin = enhance_cost
        logger.debug("before_lv %s after_lv %s " % (before_lv, after_lv))
        tlog_action.log('EquipmentEnhance', player,
                        enhance_info.get('equipment_no'),
                        equipment_id, before_lv, after_lv)

    # logger.debug(response.data)
    # logger.debug("response.data===================")
    response.num = enhance_info.get("num")

    # 更新 七日奖励
    target_update(player, [36])
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
    response = equipment_response_pb2.ComposeEquipmentResponse()

    data = compose_equipment(equipment_chip_no, player)
    result = data.get('result')
    res = response.res
    if not result:
        res.result_no = data.get('result_no')
        res.message = data.get('message')
        return response.SerializePartialToString()

    equipment_obj = data.get('equipment_obj')
    equ = response.equ
    equipment_obj.update_pb(equ)
    tlog_action.log('EquipmentCompose', player,
                    equipment_obj.base_info.equipment_no,
                    equipment_obj.base_info.id)

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
    response = equipment_response_pb2.MeltingEquipmentResponse()

    equipment_ids = request.id

    total_strength_coin = 0
    for equipment_id in equipment_ids:
        total_strength_coin += melting_equipment(equipment_id,
                                                 response,
                                                 player)

    player.finance.coin += total_strength_coin
    player.finance.save_data()

    #response.cgr.finance.coin += total_strength_coin
    change = response.cgr.finance.finance_changes.add()
    change.item_type = 107
    change.item_num = total_strength_coin
    change.item_no = 1
    response.res.result = True
    logger.debug("response %s" % response)
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

    logger.debug(response)
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


def enhance_equipment(equipment_id, enhance_type, player):
    """装备强化
    @param dynamic_id:  客户端动态ID
    @param equipment_id: 装备ID
    @param enhance_type: 强化类型
    @param kwargs:
    @return:
    """
    if is_not_open(player, FO_EQUIP_ENHANCE):
        return {"result": False, "result_no": 837}

    equipment_obj = player.equipment_component.get_equipment(equipment_id)
    # print equipment_obj, "equipment_obj"

    if enhance_type == 2 and not player.base_info.equipment_strength_one_key:
        logger.debug('enhance_equipment_vip_error!%d' %
                     player.base_info.equipment_strength_one_key)
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

    strength_max = equipment_obj.strength_max(player)
    current_strength_lv = equipment_obj.attribute.strengthen_lv

    if strength_max <= current_strength_lv:
        return {'result': False, 'result_no': 402, 'message': u''}

    num = 0
    if enhance_type == 1:
        result = __do_enhance(player, equipment_obj)
        if result.get('record')[1] >= strength_max:
            result['record'] = (result.get('record')[0], strength_max, result.get('record')[2])
        enhance_record.append(result.get('record'))
        num += 1
    else:
        while strength_max > current_strength_lv and curr_coin > enhance_cost:
            num += 1
            result = __do_enhance(player, equipment_obj)
            if not result.get('result'):
                return result

            if result.get('record')[1] >= strength_max:
                result['record'] = (result.get('record')[0], strength_max, result.get('record')[2])
                enhance_record.append(result.get('record'))
                break
            enhance_record.append(result.get('record'))
            current_strength_lv = equipment_obj.attribute.strengthen_lv
            enhance_cost = equipment_obj.attribute.enhance_cost  # 强化消耗
            curr_coin = player.finance.coin  # 用户金币

    print equipment_obj.enhance_record
    equipment_obj.enhance_record.enhance_record.extend(enhance_record)

    # 保存
    equipment_obj.save_data()
    player.finance.save_data()

    return {'result': True, 'enhance_record': enhance_record, 'num': num,
            'equipment_no': equipment_obj.base_info.equipment_no}


def __do_enhance(player, equipment_obj):
    """
    @param player:  用户对象
    @param equipment_obj: 装备对象
    @return: {'before_lv':1, 'after_lv':2, 'cost_coin':21}
    """
    enhance_cost = equipment_obj.attribute.enhance_cost  # 强化消耗
    player.finance.consume(const.COIN, enhance_cost, const.ENHANCE_EQUIPMENT)
    player.finance.save_data()

    before_lv, after_lv = equipment_obj.enhance(player)

    return {'result': True, 'record': (before_lv, after_lv, enhance_cost)}


def compose_equipment(chip_no, player):
    """合成装备
    """
    if is_not_open(player, FO_EQUIP_COMPOSE):
        return {"result": False, "result_no": 837}
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
    notice_item = game_configs.notes_config.get(2007)
    if equipment_obj.equipment_config_info.quality in notice_item.parameter1:
        push_notice(2007, player_name=player.base_info.base_name, equipment_no=chip.combine_result)

    return {'result': True, 'equipment_obj': equipment_obj}


def melting_equipment(equipment_id, response, player):
    """熔炼
    @param dynamic_id:
    @param equipment_ids:
    @param kwargs:
    @return:
    """
    if is_not_open(player, FO_EQUIP_SACRIFICE):
        return {"result": False, "result_no": 837}
    equipment_obj = player.equipment_component.get_equipment(equipment_id)
    if not equipment_obj:
        return {'result': False, 'result_no': 401, 'message': u''}
    melting_items = equipment_obj.melting_item
    gain = item_group_helper.gain(player, melting_items, const.MELTING_EQUIPMENT)

    item_group_helper.get_return(player, gain, response.cgr)

    tlog_action.log('EquipmentMelting', player,
                    equipment_obj.base_info.equipment_no,
                    equipment_obj.base_info.id)

    # 删除装备
    player.equipment_component.delete_equipment(equipment_id)

    # 添加强化金币
    strength_coin = 0
    for record in equipment_obj.enhance_record.enhance_record:
        strength_coin += record[2]

    strength_coin = int(strength_coin*game_configs.base_config.get("equRefundRatio"))
    return strength_coin


def awakening_equipment(equipment_id, player):
    """觉醒
    @param dynamic_id:
    @param equipment_id:
    @param kwargs:
    @return:
    """
    pass
