# -*- coding:utf-8 -*-
"""
created by wzp on 15-12-14下午5:22.
"""
from shared.db_opear.configs_data import game_configs
from gfirefly.server.logobj import logger

FO_CHAT = 1
FO_HERO_BREAK = 2
FO_HERO_AWAKE = 3
FO_HERO_SACRIFICE = 4
FO_HERO_COMPOSE = 5
FO_FRIEND_SUPPORT = 18
FO_CHANGE_EQUIPMENT = 19
FO_EQUIP_ENHANCE = 20
FO_EQUIP_SACRIFICE = 21
FO_EQUIP_COMPOSE = 22
FO_EQUIP_SHOP = 23

FO_ACT_STAGE = 24
FO_ELI_STAGE = 25
FO_HJQY_STAGE = 26
FO_EX_SPEED = 27
FO_GUILD = 28
FO_REFINE = 29
FO_RUNT_ADD = 30
FO_MINE = 31

FO_TRAVEL = 33
FO_INHERIT = 34
FO_ROB_TREASURE = 35
FO_UNPARA = 36
FO_PVP_RANK = 37
FO_ACTIVITY = 38


def is_not_open(player, feature_type):
    """
    是否开启
    """
    logger.debug("feature_type %s player_level %s" % (feature_type,
                                                      player.base_info.level))
    feature_item = game_configs.features_open_config.get(feature_type)
    if not feature_item:
        logger.error("there is no such feature_type %s!" % feature_type)
        return True
    logger.debug("open_type %s open %s" % (feature_item.open_type,
                                           feature_item.open))

    if feature_item.open_type == 1:
        # 玩家等级
        if feature_item.open <= player.base_info.level:
            return False
        else:
            return True

    if feature_item.open_type == 2:
        # 关卡
        open_stage_id = feature_item.open
        if player.stage_component.get_stage(open_stage_id).state == 1:
            return False
        else:
            return True
    return True
