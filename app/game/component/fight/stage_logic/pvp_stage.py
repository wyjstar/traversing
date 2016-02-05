#!/usr/bin/env python
# -*- coding: utf-8 -*-
from gfirefly.server.logobj import logger
from shared.utils.const import const


class PvpStageLogic():
    """docstring for 活动关卡"""
    def update_hero_self_attr(self, hero_no, hero_self_attr, player):
        """
        update hero self attr, plus some attr
        """
        add_buffs = player.pvp.pvp_overcome_buff
        lucky_add = 0

        logger.debug("add_buffs %s" % add_buffs)

        print("hero_self_attr_origin", hero_self_attr)
        for attr_info in add_buffs.values():
            if not attr_info[0]: continue
            attr_name = const.ATTR_TYPE.get(int(attr_info[0]))
            if attr_info[1] == 2:
                lucky_add = hero_self_attr[attr_name] * attr_info[2]
            elif attr_info[1] == 1:
                lucky_add = attr_info[2]
            logger.debug("===========%s %s" % (hero_self_attr[attr_name], lucky_add))
            hero_self_attr[attr_name] = hero_self_attr[attr_name] + lucky_add
        print("hero_self_attr_after", hero_self_attr)

        return hero_self_attr
