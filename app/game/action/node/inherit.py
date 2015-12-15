#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import inherit_pb2, common_pb2
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger
from shared.tlog import tlog_action
from shared.utils.const import const
from shared.common_logic.feature_open import is_not_open, FO_INHERIT


@remoteserviceHandle('gate')
def inherit_refine_151(pro_data, player):
    """
    炼体传承
    """
    request = inherit_pb2.InheritRefineRequest()
    request.ParseFromString(pro_data)
    origin_id = request.origin
    target_id = request.target

    response = common_pb2.CommonResponse()

    origin = player.hero_component.get_hero(origin_id)
    target = player.hero_component.get_hero(target_id)

    if is_not_open(player, FO_INHERIT):
        response.result = False
        response.result_no = 837
        return response.SerializeToString()

    print "origin:", origin.refine, "target:", target.refine
    if not origin or (not target):
        logger.error("hero %s or %s not exists" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()

    if not origin.refine:
        logger.error("origin hero %s do not have refine!" % origin_id)
        response.result = False
        return response.SerializeToString()

    if origin.refine <= target.refine:
        logger.error("origin hero %s refine <= target hero %s refine!" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()
    i_value = 0

    def func():
        target.refine = origin.refine
        origin.refine = 0
        target.save_data()
        origin.save_data()
        i_value = target.refine
    gold = game_configs.base_config.get("heroInheritPrice")
    player.pay.pay(gold, const.INHERIT_REFINE, func)

    player.finance.save_data()
    response.result = True
    tlog_action.log('Inherit', player, 1, 0, origin_id, 0, target_id, i_value)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def inherit_equipment_152(pro_data, player):
    """
    装备传承
    """
    request = inherit_pb2.InheritEquipmentRequest()
    request.ParseFromString(pro_data)
    origin_id = request.origin
    target_id = request.target

    response = common_pb2.CommonResponse()

    if is_not_open(player, FO_INHERIT):
        response.result = False
        response.result_no = 837
        return response.SerializeToString()
    origin = player.equipment_component.get_equipment(origin_id)
    target = player.equipment_component.get_equipment(target_id)
    # print origin.attribute.strengthen_lv, target.attribute.strengthen_lv, "+"*10

    if not origin or (not target):
        logger.error("equip %s or %s not exists" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()

    if origin.attribute.strengthen_lv <= target.attribute.strengthen_lv:
        logger.error("origin equip %s strengthen_lv <= target equip %s strengthen_lv!" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()

    if origin.equipment_config_info.get("quality") != target.equipment_config_info.get("quality"):
        logger.error("origin.quality!=target.quality")
        response.result = False
        return response.SerializeToString()

    i_value = 0

    def func():
        """docstring for func"""
        target.attribute.strengthen_lv = origin.attribute.strengthen_lv
        i_value = target.attribute.strengthen_lv

        origin.attribute.strengthen_lv = 1
        # 传承强化过程
        target.enhance_record.enhance_record = origin.enhance_record.enhance_record
        origin.enhance_record.enhance_record = []

        target.save_data()
        origin.save_data()
        print origin.attribute.strengthen_lv, target.attribute.strengthen_lv, "+"*10

    gold = game_configs.base_config.get("equInheritPrice")
    player.pay.pay(gold, const.INHERIT_EQUIPMENT, func)
    response.result = True
    tlog_action.log('Inherit', player, 2, origin.base_info.id,
                    origin.base_info.equipment_no,
                    target.base_info.id,
                    target.base_info.equipment_no,
                    i_value)
    return response.SerializeToString()


@remoteserviceHandle('gate')
def inherit_upara_153(pro_data, player):
    """
    无双传承
    """
    request = inherit_pb2.InheritUnparaRequest()
    request.ParseFromString(pro_data)
    origin_id = request.origin
    target_id = request.target

    response = common_pb2.CommonResponse()

    if is_not_open(player, FO_INHERIT):
        response.result = False
        response.result_no = 837
        return response.SerializeToString()

    origin_level = player.line_up_component.unpars.get(origin_id)
    target_level = player.line_up_component.unpars.get(target_id)

    if not origin_level:
        logger.error("unpara %s or %s not exists" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()

    if origin_level <= target_level:
        logger.error("origin.level!=target.level")
        response.result = False
        return response.SerializeToString()

    def func():
        player.line_up_component.unpars[target_id] = origin_level
        player.line_up_component.unpars[origin_id] = 1
        player.line_up_component.save_data()

    need_gold = game_configs.base_config.get("warriorsInheritPrice")
    player.pay.pay(need_gold, const.INHERIT_UPARA, func)
    response.result = True
    tlog_action.log('Inherit', player, 1, 0, origin_id, 0, target_id, 0)
    return response.SerializeToString()
