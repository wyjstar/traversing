# -*- coding:utf-8 -*-
"""
created by server on 14-6-10下午9:09.
"""
from shared.db_entrust.redis_mode import MAdmin

tb_character_info = MAdmin('tb_character_info', 'uid')
tb_character_info.insert()

tb_equipment_list = MAdmin('tb_equipment_list', 'uid')
tb_equipment_list.insert()