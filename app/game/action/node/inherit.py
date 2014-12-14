#!/usr/bin/env python
# -*- coding: utf-8 -*-
"""
created by wzp.
"""
from gfirefly.server.globalobject import remoteserviceHandle
from app.proto_file import inherit_pb2, common_pb2
from shared.db_opear.configs_data.game_configs import base_config
from gfirefly.server.logobj import logger

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

    target.refine = origin.refine
    origin.refine = 0

    player.finance.gold -= base_config.get("heroInheritPrice")
    player.finance.save_data()
    response.result = True
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

    origin = player.equipment_component.get_equipment(origin_id)
    target = player.equipment_component.get_equipment(target_id)
    print origin.attribute.strengthen_lv, target.attribute.strengthen_lv, "+"*10

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

    target.attribute.strengthen_lv = origin.attribute.strengthen_lv
    target.save_data()

    origin.attribute.strengthen_lv = 1
    origin.save_data()
    # 传承强化过程
    target.enhance_record.enhance_record = origin.enhance_record.enhance_record
    origin.enhance_record.enhance_record = []

    print origin.attribute.strengthen_lv, target.attribute.strengthen_lv, "+"*10

    player.finance.gold -= base_config.get("equInheritPrice")
    player.finance.save_data()
    response.result = True
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

    origin_level = player.line_up_component.unpars.get(origin_id)
    target_level = player.line_up_component.unpars.get(target_id)

    if not origin_level or (not target_level):
        logger.error("unpara %s or %s not exists" % (origin_id, target_id))
        response.result = False
        return response.SerializeToString()

    if origin_level <= target_level:
        logger.error("origin.level!=target.level")
        response.result = False
        return response.SerializeToString()

    player.line_up_component.unpars[target_id] = origin_id
    player.line_up_component.unpars[origin_id] = 1
    player.line_up_component.save_data()

    player.finance.gold -= base_config.get("warriorsInheritPrice")
    player.finance.save_data()
    response.result = True
    return response.SerializeToString()
