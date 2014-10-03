# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""



def init_player(player):
    player.finance.coin = 3000000*100
    player.finance.hero_soul = 2000000
    player.finance.gold = 1000000*100
    player.finance.save_data()

    player.level.level = 60
    player.level.exp = 100
    player.vip_component.vip_level = 3
    player.line_up_component.update_slot_activation()
    player.last_pick_time.fine_hero = 0
    player.last_pick_time.excellent_hero = 0
    player.last_pick_time.fine_equipment = 0
    player.last_pick_time.excellent_equipment = 0
    player.last_pick_time.save_data()
    player.save_data()
