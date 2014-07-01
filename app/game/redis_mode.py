# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from shared.db_entrust.redis_mode import MAdmin

tb_character_info = MAdmin('tb_character_info', 'uid')
tb_character_info.insert()

tb_char_hero = MAdmin('tb_char_hero', 'id',1800, fk='characterid')
tb_char_hero.insert()

tb_char_hero_chip = MAdmin('tb_char_hero_chip', 'id',1800, fk='characterid')
tb_char_hero_chip.insert()