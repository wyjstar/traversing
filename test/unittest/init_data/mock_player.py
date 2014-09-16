# -*- coding:utf-8 -*-
"""
created by server on 14-7-4上午10:30.
"""

from app.game.core.character.PlayerCharacter import PlayerCharacter
from app.game.core.PlayersManager import PlayersManager
from app.game.redis_mode import tb_character_info


def init_player():
    character_obj = tb_character_info.getObj(1)
    if not character_obj:
        character = {'id': 1,
                     'nickname': '',
                     'coin': 0,
                     'gold': 0,
                     'hero_soul': 0,
                     'level': 200,
                     'exp': 0,
                     'junior_stone': 0,
                     'middle_stone': 0,
                     'high_stone': 0,
                     'fine_hero_last_pick_time': 0,
                     'excellent_hero_last_pick_time': 0,
                     'fine_equipment_last_pick_time': 0,
                     'excellent_equipment_last_pick_time': 0,
                     'stamina': 100,
                     'pvp_times': 0,
                     'vip_level': 0,
                     'get_stamina_times': 0}
        tb_character_info.new(character)

    PlayersManager().drop_player_by_id(1)
    player = PlayerCharacter(1, name="wzp", dynamic_id=1, status=1)
    player.finance.coin = 30000
    player.finance.hero_soul = 20000
    player.finance.gold = 10000
    player.finance.save_data()

    player.last_pick_time.fine_hero = 0
    player.last_pick_time.excellent_hero = 0
    player.last_pick_time.fine_equipment = 0
    player.last_pick_time.excellent_equipment = 0
    player.last_pick_time.save_data()

    PlayersManager().add_player(player)

    character_obj = tb_character_info.getObj(2)
    if not character_obj:
        character = {'id': 2,
                     'nickname': '',
                     'coin': 0,
                     'gold': 0,
                     'hero_soul': 0,
                     'level': 0,
                     'exp': 0,
                     'junior_stone': 0,
                     'middle_stone': 0,
                     'high_stone': 0,
                     'fine_hero_last_pick_time': 0,
                     'excellent_hero_last_pick_time': 0,
                     'fine_equipment_last_pick_time': 0,
                     'excellent_equipment_last_pick_time': 0,
                     'stamina': 100,
                     'pvp_times': 0,
                     'vip_level': 0,
                     'get_stamina_times': 0}
        tb_character_info.new(character)

    PlayersManager().drop_player_by_id(2)
    player = PlayerCharacter(2, dynamic_id=2, status=1)
    player.finance.coin = 30000
    player.finance.hero_soul = 20000
    player.finance.gold = 10000
    player.finance.save_data()

    player.last_pick_time.fine_hero = 0
    player.last_pick_time.excellent_hero = 0
    player.last_pick_time.fine_equipment = 0
    player.last_pick_time.excellent_equipment = 0
    player.last_pick_time.save_data()

    PlayersManager().add_player(player)
