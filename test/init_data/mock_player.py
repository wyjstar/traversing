# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""
from shared.utils.const import const


def init_player(player):
    player.finance[const.COIN] = 10000000
    player.finance[const.GOLD] = 10000000
    player.finance[const.HERO_SOUL] = 10000000
    player.finance[const.EQUIPMENT_ELITE] = 10000000
    player.finance[const.PVP] = 10000000
    player.finance.save_data()

    player.base_info._level = 60
    player.base_info._exp = 0
    player.base_info.vip_level = 15
    player.line_up_component.update_slot_activation()
    player.last_pick_time.fine_hero = 0
    player.last_pick_time.excellent_hero = 0
    player.last_pick_time.fine_equipment = 0
    player.last_pick_time.excellent_equipment = 0
    player.last_pick_time.save_data()
    player.base_info.save_data()
